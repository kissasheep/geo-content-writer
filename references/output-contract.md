# Output contract

Follow the existing question-package pattern unless the user requests another format.

## Required editorial outputs

- `文章.md`: complete formatted article with headings, inline relative image paths at their actual reading positions, captions or alt text, and a source note. When images are required, links inside this file are mandatory.
- `纯文本正文.txt`: clean text without Markdown image syntax or publishing metadata.
- `发布信息.txt`: title, suggested slug when relevant, category, summary, keywords, cover image, inline images, captions, image handling note, source/date note, and publication checks.
- `图片匹配表.md`: the semantic match table described in `image-matching.md`.

Create `WordPress正文.html` only when requested or when updating a package that already requires it. Copy selected images into `图片\` only when packaging is requested.

For an illustrated package, these three layers must agree:

1. `文章.md` contains the inline Markdown image path.
2. `图片匹配表.md` contains the same path and placement decision.
3. The referenced file exists under `图片\`.

Having only layer 2 or 3 is incomplete.

## Save safely

- For a new question, create a new numbered folder without renaming existing folders.
- For an existing question, do not overwrite silently. Save a reviewable draft or present the intended changes first.
- Preserve unrelated files, original images, links, hashes, and timestamps where possible.
- Never edit the raw-image pool in place.

## Completion check

Before reporting completion, verify:

- the target question is answered explicitly;
- each material factual claim has support or is clearly qualified;
- article type and voice match the requested channel;
- no fake first-person detail or generic AI-style filler remains;
- every inserted image appears in the match table and exists at the saved path;
- the article meets the selected format's default completeness range unless the user requested another length or the package visibly records an evidence shortage;
- captions describe visible facts without unsupported identity or context;
- unresolved current-information checks are listed;
- only the intended files changed.

Run `scripts/validate_geo_package.ps1` against the package root. Treat any failure as unfinished work, fix it, and rerun before reporting completion.
