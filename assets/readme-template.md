---
project_id: SPEC-YYYY-MM-DD-NNN
project_name: "{Project Name}"
slug: {project-slug}
status: draft
created: {ISO timestamp}
approved: null
started: null
completed: null
expires: {+90 days ISO timestamp}
tags: [{tags}]
stakeholders: [{names}]
shapiro_level: 4  # 2=fix | 3=minor | 4=feature | 5=system
---

# {Project Name}

{One-line summary of what this spec covers.}

## Feature Index

| # | Feature | Severity | Effort | Files |
|---|---------|----------|--------|-------|
| F1 | {title} | {Critical/High/Medium/Low} | {estimate} | {N files} |
| F2 | {title} | {severity} | {estimate} | {N files} |

## Documents

- [REQUIREMENTS.md](./REQUIREMENTS.md) — Full PRD with impact analysis, scenarios, and edge cases
- [SCENARIOS.md](./SCENARIOS.md) — Holdout validation scenarios (do NOT share with implementing agent)
- [IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md) — Phased task breakdown with convergence loop
- [DECISIONS.md](./DECISIONS.md) — ADRs for design choices
- [SYSTEM_MAP.yaml](./SYSTEM_MAP.yaml) — Component dependency graph (new or updated)
- [contracts/](./contracts/) — Boundary contract definitions (new or updated)
