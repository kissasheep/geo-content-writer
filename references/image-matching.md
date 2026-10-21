# Article-to-image matching

Image matching is an editorial evidence task, not decoration.

## Inspect first

Open each serious candidate at readable size. Record only what is visible or supplied by a reliable caption. A filename may help locate a file but cannot prove who, where, when, or what event it shows.

Reject or flag images that are blurry, misleadingly cropped, duplicated, watermarked without permission, privacy-sensitive, or impossible to contextualize accurately.

## Build the match table

Create `图片匹配表.md` with one row per selected or unresolved placement:

| Placement | Paragraph/card purpose | Image file | Visible evidence | Caption | Confidence | Risk or check |
| --- | --- | --- | --- | --- | --- | --- |

Use `high`, `medium`, or `low` confidence. Do not publish a low-confidence identity, location, date, or event claim as fact.

## Matching rules

- Cover: choose an image that identifies the main subject or central situation without implying more than the article proves.
- Inline image: place it immediately after the paragraph it supports.
- Person image: supports presence or appearance, not credentials, endorsement, ownership, or a relationship unless those are independently established.
- Food, venue, product, or document image: name it only when identification is verified.
- Event image: do not reuse it as proof of another event merely because the people or venue look similar.
- Generic atmosphere image: label it as illustrative and do not use it to support a factual claim.

Prefer fewer strong matches over filling every section. When no image genuinely supports a paragraph, leave it unillustrated or request a better image.

## Inline placement is part of delivery

For an illustrated package, insert every selected image into `文章.md` with a relative Markdown path immediately after the paragraph or card it supports:

```markdown
![准确描述画面可见内容的替代文字](图片/01_门头.jpg)

*只描述可见事实的图片说明。*
```

The same relative path must appear in `图片匹配表.md`, and the copied file must exist under the package's `图片` directory. An image folder or match table without inline Markdown placement is not a completed illustrated article.

For Douyin image-text output, each card needs its own inspected image. Avoid repeating one image across cards merely to meet the card count; reuse only when the same image genuinely supports both jobs and the user accepts repetition.

## File handling

When packaging is requested, copy the untouched original into the question folder's `图片` directory, use a stable ordered filename, and update inline paths, captions, and the match table. Do not move the raw source. If checksums are part of the package, regenerate them only for the copied files and state that this was done.
