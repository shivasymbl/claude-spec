---
document_type: implementation_plan
project_id: {PROJECT_ID}
version: 1.0.0
last_updated: {TIMESTAMP}
status: draft
estimated_effort: {total estimate}
shapiro_level: 4  # 2=fix | 3=minor | 4=feature | 5=system
---

# {Project Name} — Implementation Plan

## Phase Summary

| Phase | Duration | Features | Key Deliverables |
|-------|----------|----------|------------------|
| Phase 1: Critical | {est} | F1 | {deliverable} |
| Phase 2: Core | {est} | F2, F3 | {deliverable} |
| Phase 3: Validate | {est} | — | Convergence gate (automatic) |

---

## Phase 1: {Name}

### Task 1.1: {Title}

**Files:** `{file path}`
**Effort:** {estimate}

**Steps:**
1. {step with exact code change}
2. {step}

**Verify:** `npx tsc --noEmit` or `{test command}` → exit 0
**Commit:** `{type}({scope}): {description}`

---

## Phase N: Validate & Converge

{This phase runs AFTER implementation. It validates against holdout scenarios from SCENARIOS.md.}

### Convergence gate (automatic — do not add as manual task)

**DO NOT include explicit steps to read or execute SCENARIOS.md here.**
The convergence gate runs automatically in /implement after all tasks complete.
Adding it as a manual task exposes the holdout set to the implementer and breaks
the holdout validation property.

The convergence gate is triggered by /implement when project_status transitions
toward completion. It is NOT a task the implementer executes.

**Convergence criteria:**
- 90%+ scenarios score Satisfied
- 0 scenarios score Not Satisfied on critical paths
- All regression scenarios pass

**If not converging:**
- Identify which scenarios fail
- Trace failure to specific feature requirement
- Create fix tasks, re-run scenarios
- Loop until convergence criteria met

### Task N.2: Regression Gate

**Steps:**
1. Run full test suite: `{test command}`
2. Verify no existing behavior is broken
3. Confirm all acceptance scenarios from REQUIREMENTS.md still pass

**Verify:** All tests green + holdout satisfaction >= 90%

---

## Dependency Graph

```text
Phase 1: Task 1.1 → Task 1.2
    ↓
Phase 2: Task 2.1 → Task 2.2
    ↓
Phase N: Validate → Converge (loop until satisfied)
```

---

## Convergence Loop

{For Level 4-5 work. Skip for simple fixes.}

```text
┌─────────────────────────────────────────┐
│  Implement Phase N                      │
│         ↓                               │
│  Run Holdout Scenarios                  │
│         ↓                               │
│  Score Satisfaction                     │
│         ↓                               │
│  >= 90% satisfied? ──YES──→ Ship        │
│         │                               │
│         NO                              │
│         ↓                               │
│  Identify failing scenarios             │
│         ↓                               │
│  Trace to requirements                  │
│         ↓                               │
│  Fix → Re-run (loop back to top)        │
└─────────────────────────────────────────┘
```

**Max iterations before escalation:** 3
{If 3 loops don't converge, the spec needs revision, not more code.}

---

## Post-Ship Observability

{What do we monitor after this ships? Skip for trivial fixes.}

| Signal | How We Monitor | Alert Threshold |
|--------|---------------|-----------------|
| {metric} | {dashboard/log/alert} | {when to page} |

**Rollback plan:** {how to undo if things go wrong}

**Success validation (7 days post-ship):**
- [ ] {metric holding steady}
- [ ] {no regression in adjacent features}
- [ ] {user feedback positive or neutral}

---

## System Context Maintenance

{After implementation, update the living artifacts. This is not optional cleanup — it's a required deliverable.}

- [ ] **SYSTEM_MAP.yaml** updated to reflect new/changed components
- [ ] **Boundary contracts** versioned for any changed interfaces
- [ ] **Consumer tests** added or updated for changed contracts
- [ ] **No orphaned references** — every consumer of a changed contract has been updated

---

## Verification Checklist

- [ ] `npx tsc --noEmit` exits 0 (or equivalent type check)
- [ ] All acceptance scenarios pass
- [ ] All contract consumers still work (no downstream breakage)
- [ ] Holdout satisfaction >= 90%
- [ ] Regression scenarios pass
- [ ] System map and contracts updated
- [ ] {feature-specific check}
- [ ] Post-ship observability configured
