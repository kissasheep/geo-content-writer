param(
    [Parameter(Mandatory = $true)]
    [string]$Root
)

$ErrorActionPreference = 'Stop'

function Get-Profile {
    param([string]$FolderName)

    if ($FolderName -match '搜索|新闻') {
        return @{ Name = 'search/news'; MinChars = 1200; MinImages = 4 }
    }
    if ($FolderName -match '小红书') {
        return @{ Name = 'xiaohongshu'; MinChars = 800; MinImages = 4 }
    }
    if ($FolderName -match '抖音') {
        return @{ Name = 'douyin'; MinChars = 700; MinImages = 6 }
    }
    if ($FolderName -match '知识|科普') {
        return @{ Name = 'knowledge'; MinChars = 1500; MinImages = 4 }
    }
    return @{ Name = 'generic'; MinChars = 600; MinImages = 1 }
}

function Get-ReadableLength {
    param([string]$Markdown)

    $text = $Markdown -replace '!\[[^\]]*\]\([^\)]*\)', ''
    $text = $text -replace '[#*`|_\-]', ''
    return $text.Trim().Length
}

$resolvedRoot = [System.IO.Path]::GetFullPath($Root)
if (-not (Test-Path -LiteralPath $resolvedRoot -PathType Container)) {
    Write-Error "Package root does not exist: $resolvedRoot"
    exit 2
}

$articles = @(Get-ChildItem -LiteralPath $resolvedRoot -Recurse -File -Filter '文章.md')
if ($articles.Count -eq 0) {
    Write-Error "No 文章.md found under: $resolvedRoot"
    exit 2
}

$errors = [System.Collections.Generic.List[string]]::new()
$rows = [System.Collections.Generic.List[object]]::new()
$requiredFiles = @('文章.md', '纯文本正文.txt', '发布信息.txt', '图片匹配表.md')

foreach ($articleFile in $articles) {
    $packageDir = $articleFile.Directory.FullName
    $packageName = $articleFile.Directory.Name
    $profile = Get-Profile -FolderName $packageName

    foreach ($required in $requiredFiles) {
        $requiredPath = Join-Path $packageDir $required
        if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
            $errors.Add("[$packageName] missing required file: $required")
        }
    }

    $article = Get-Content -LiteralPath $articleFile.FullName -Raw
    $readableLength = Get-ReadableLength -Markdown $article
    if ($readableLength -lt $profile.MinChars) {
        $errors.Add("[$packageName] article is too short: $readableLength < $($profile.MinChars) characters for $($profile.Name)")
    }

    $imageMatches = @([regex]::Matches($article, '!\[[^\]]*\]\((图片[\\/][^\)]+)\)'))
    if ($imageMatches.Count -lt $profile.MinImages) {
        $errors.Add("[$packageName] too few inline images: $($imageMatches.Count) < $($profile.MinImages) for $($profile.Name)")
    }

    $tablePath = Join-Path $packageDir '图片匹配表.md'
    $table = if (Test-Path -LiteralPath $tablePath -PathType Leaf) {
        Get-Content -LiteralPath $tablePath -Raw
    } else {
        ''
    }

    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($match in $imageMatches) {
        $relative = $match.Groups[1].Value
        $normalized = $relative -replace '/', [System.IO.Path]::DirectorySeparatorChar
        $imagePath = Join-Path $packageDir $normalized

        if (-not $seen.Add($relative)) {
            $errors.Add("[$packageName] duplicate inline image: $relative")
        }
        if (-not (Test-Path -LiteralPath $imagePath -PathType Leaf)) {
            $errors.Add("[$packageName] inline image does not exist: $relative")
        }
        if ($table -and $table -notmatch [regex]::Escape($relative)) {
            $errors.Add("[$packageName] inline image missing from 图片匹配表.md: $relative")
        }
    }

    if ($article -notmatch '资料说明|来源说明|资料来源|Sources?') {
        $errors.Add("[$packageName] article has no source/date note")
    }

    $plainPath = Join-Path $packageDir '纯文本正文.txt'
    if (Test-Path -LiteralPath $plainPath -PathType Leaf) {
        $plain = Get-Content -LiteralPath $plainPath -Raw
        if ($plain -match '!\[[^\]]*\]\([^\)]*\)') {
            $errors.Add("[$packageName] 纯文本正文.txt contains Markdown image syntax")
        }
    }

    $rows.Add([pscustomobject]@{
        Package = $packageName
        Profile = $profile.Name
        Characters = $readableLength
        InlineImages = $imageMatches.Count
    })
}

$rows | Format-Table -AutoSize | Out-String | Write-Output

if ($errors.Count -gt 0) {
    Write-Output 'VALIDATION FAILED'
    foreach ($item in $errors) {
        Write-Output "- $item"
    }
    exit 1
}

Write-Output "VALIDATION PASSED: $($articles.Count) package(s) checked."
exit 0
