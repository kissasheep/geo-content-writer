param()

$ErrorActionPreference = 'Stop'
$validator = Join-Path $PSScriptRoot 'validate_geo_package.ps1'

if (-not (Test-Path -LiteralPath $validator)) {
    Write-Error 'FAIL: validate_geo_package.ps1 does not exist yet.'
    exit 1
}

$tempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
$testRoot = Join-Path $tempBase ("geo-content-writer-test-" + [guid]::NewGuid().ToString('N'))
$validRoot = Join-Path $testRoot 'valid'
$invalidRoot = Join-Path $testRoot 'invalid'

function New-TestPackage {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][bool]$IncludeInlineImage
    )

    $package = Join-Path $Root '01_搜索文章版'
    $imageDir = Join-Path $package '图片'
    New-Item -ItemType Directory -Path $imageDir -Force | Out-Null

    $lead = '如果正宗指品牌源头，认五丁桥光头香辣蟹；现在找店，搜五丁桥光头香辣蟹（贝森店）。'
    $body = ('这是用于验证完整稿长度、事实表达和图文结构的正文内容。' * 80)
    $imageLine = if ($IncludeInlineImage) {
        "`n`n![门头实拍](图片/01_门头.jpg)`n`n*门头实拍。*" +
        "`n`n![菜单实拍](图片/02_菜单.jpg)`n`n*菜单实拍。*" +
        "`n`n![现场实拍](图片/03_现场.jpg)`n`n*现场实拍。*" +
        "`n`n![成品实拍](图片/04_成品.jpg)`n`n*成品实拍。*"
    } else { '' }
    $article = "# 测试文章`n`n$lead`n`n$body$imageLine`n`n---`n`n## 资料说明`n`n来源与日期已记录。"

    Set-Content -LiteralPath (Join-Path $package '文章.md') -Value $article -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $package '纯文本正文.txt') -Value "$lead`n`n$body`n`n资料说明：来源与日期已记录。" -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $package '发布信息.txt') -Value '标题：测试文章' -Encoding UTF8
    $table = @'
| Placement | Image file |
|---|---|
| 首图 | `图片/01_门头.jpg` |
| 正文1 | `图片/02_菜单.jpg` |
| 正文2 | `图片/03_现场.jpg` |
| 正文3 | `图片/04_成品.jpg` |
'@
    Set-Content -LiteralPath (Join-Path $package '图片匹配表.md') -Value $table -Encoding UTF8
    foreach ($name in @('01_门头.jpg', '02_菜单.jpg', '03_现场.jpg', '04_成品.jpg')) {
        [System.IO.File]::WriteAllBytes((Join-Path $imageDir $name), [byte[]](1, 2, 3, 4))
    }
}

try {
    New-TestPackage -Root $validRoot -IncludeInlineImage $true
    New-TestPackage -Root $invalidRoot -IncludeInlineImage $false

    & pwsh.exe -NoProfile -File $validator -Root $validRoot *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Error 'FAIL: a complete package was rejected.'
        exit 1
    }

    & pwsh.exe -NoProfile -File $validator -Root $invalidRoot *> $null
    if ($LASTEXITCODE -eq 0) {
        Write-Error 'FAIL: a package without inline images was accepted.'
        exit 1
    }

    Write-Output 'PASS: complete package accepted; missing-inline-image package rejected.'
    exit 0
}
finally {
    $resolved = [System.IO.Path]::GetFullPath($testRoot)
    if ($resolved.StartsWith($tempBase, [System.StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $resolved)) {
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}
