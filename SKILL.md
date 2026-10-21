---
name: geo-content-writer
description: Use when creating or revising Chinese GEO news/search articles, Xiaohongshu posts, Douyin image-text posts, or knowledge explainers from a question library, verified source material, and real images.
---

# GEO Content Writer

Create useful, source-grounded Chinese content that answers a concrete GEO question and pairs every image with the claim or scene it genuinely supports.

Default to a complete, publication-ready draft. A request to “test” a question means testing the full workflow unless the user explicitly asks for an outline, sample, short draft, or word limit.

## Non-negotiable boundaries

- Use the user's question library, source material, and real images. Do not invent facts, credentials, dates, quotes, personal experiences, locations, or image context.
- Do not generate, retouch, crop, compress, add text to, or otherwise alter images unless the user explicitly asks. Preserve originals when packaging selected images.
- Inspect an image before describing or selecting it. Never infer its contents only from a filename.
- When images are part of the deliverable, insert every selected image into `文章.md` at its actual reading position. Copying images into a folder or listing them only in `图片匹配表.md` is not a finished illustrated article.
- Treat missing evidence as a visible gap. Narrow the claim, add a verification note, or ask for the missing material instead of filling it with plausible prose.
- Keep publication type and voice distinct. A news report, Xiaohongshu post, Douyin image-text sequence, and knowledge explainer must not sound like the same template.
- Natural writing does not permit fabricated imperfection or fake first-person experience.
- Do not turn evidence handling into editorial commentary inside the body. Put verification limits, time-sensitive checks, and image-use cautions in the final source note unless they directly change the reader's decision.

## Workflow

1. Read [references/local-project.md](references/local-project.md) when working in this installed GEO folder.
2. Read [references/workflow.md](references/workflow.md) for input triage, evidence handling, and revision order.
3. Read the requested format in [references/formats.md](references/formats.md).
4. Read [references/natural-writing.md](references/natural-writing.md) before drafting or revising.
5. When images are available or required, read [references/image-matching.md](references/image-matching.md) and build the match table before finalizing the article.
6. Before saving deliverables, follow [references/output-contract.md](references/output-contract.md).

## Default operating rules

- Answer the target question early and explicitly. Use stable entity names, concrete nouns, and unambiguous relationships; do not stuff keywords.
- Separate verified facts, user-provided claims, direct observation, and interpretation. Attribute each at the appropriate level.
- Prefer a smaller set of well-supported claims over a broad but thin article.
- Meet the default completeness range for the selected format when evidence is sufficient. If evidence is insufficient, narrow the scope visibly; never repeat sentences or add generic background merely to reach a length target.
- Match images by meaning: subject, action, place, time, and the paragraph's claim. A merely attractive image is not automatically a valid match.
- Deliver a publication-ready draft plus a compact record of sources, unresolved checks, and image placement decisions.
- If editing an existing question package, review the proposed differences before replacing any file. Preserve unrelated files.

## Validation

For a packaged deliverable, run:

```powershell
pwsh -NoProfile -File scripts/validate_geo_package.ps1 -Root "<package-root>"
```

The validator checks required files, default content length, inline image count, image existence, image-table coverage, source notes, and clean plain-text output. A package is not complete while this command reports a failure.
