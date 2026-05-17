---
document_type: scenarios
project_id: {PROJECT_ID}
version: 1.0.0
last_updated: {TIMESTAMP}
status: draft
---

# {Project Name} — Validation Scenarios (Holdout)

## Purpose

This document contains **holdout validation scenarios** — end-to-end user journeys used to evaluate whether the implementation actually satisfies the user, not just whether it passes tests.

Inspired by StrongDM's Software Factory methodology: scenarios are treated like ML holdout sets. The implementing agent should NOT reference this document during implementation. These scenarios are used AFTER implementation to validate satisfaction.

**Key distinction:**
- **Acceptance Scenarios** (in REQUIREMENTS.md) → visible to implementer, define correct behavior
- **Holdout Scenarios** (this document) → hidden from implementer, validate real-world satisfaction

## Satisfaction Framing

Traditional testing asks: "Does it pass?"
Satisfaction testing asks: "If a real person used this in all the ways a real person might, how often would it actually do what they needed?"

Score each scenario trajectory as:
- **Satisfied** — the user would consider this successful
- **Partially satisfied** — works but with friction, missing polish, or workaround needed
- **Not satisfied** — the user would consider this a failure

**Target: 90%+ satisfaction across all scenarios.**

---

## Scenario Format

```markdown
### S{N}: {Scenario Title}

**Persona:** {Who is doing this? Role, context, skill level}
**Goal:** {What are they trying to accomplish? In their words, not ours.}
**Entry point:** {Where do they start? What state is the system in?}

**Journey:**
1. {User does X}
   → System should {Y}
2. {User does A}
   → System should {B}
3. {User observes result}
   → {What "satisfied" looks like}

**Satisfaction criteria:**
- {What makes this a success from the user's perspective}
- {Time constraint, if relevant}
- {Quality bar, if relevant}

**Adversarial variant:** {A way to try to break it — unusual input, edge case timing, unexpected user behavior}
```

---

## Happy Path Scenarios

### S1: {Title}

**Persona:** {description}
**Goal:** {description}
**Entry point:** {description}

**Journey:**
1. {step} → {expected}
2. {step} → {expected}
3. {step} → {expected}

**Satisfaction criteria:**
- {criterion}

**Adversarial variant:** {description}

---

## Edge Case Scenarios

### S{N}: {Title — unusual input, boundary condition, or timing issue}

**Persona:** {description}
**Goal:** {description}
**Entry point:** {description — note what makes this an edge case}

**Journey:**
1. {step} → {expected}

**Satisfaction criteria:**
- {criterion — note: partial satisfaction is acceptable for edge cases if graceful}

**Adversarial variant:** {description}

---

## Failure & Recovery Scenarios

### S{N}: {Title — what happens when things go wrong}

**Persona:** {description}
**Goal:** {They're trying to recover from an error or unexpected state}
**Entry point:** {System is in a bad state because...}

**Journey:**
1. {User encounters error}
   → System should {communicate clearly what happened}
2. {User attempts recovery}
   → System should {guide toward resolution}

**Satisfaction criteria:**
- User understands what went wrong without technical jargon
- Recovery path exists and works
- No data loss or corruption

---

## Regression Scenarios

{Scenarios that validate existing behavior is preserved. These are especially important for fixes and refactors.}

### S{N}: {Title — existing behavior that must not break}

**Pre-condition:** {What worked before}
**Post-implementation:** {Must still work identically}

---

## Contract & Integration Scenarios

{Scenarios that validate boundary contracts are honored. For every changed contract, every consumer gets a scenario.}

### S{N}: {Consumer Name} still works after {Contract Name} change

**Persona:** {The downstream consumer — could be a service, user, or agent}
**Goal:** {Consumer performs its normal operation using the changed interface}
**Entry point:** {Consumer calls / reads / receives from the changed boundary}

**Journey:**
1. {Consumer sends request / reads data in the format it expects}
   → System should {respond correctly, honoring backward compatibility}
2. {Consumer processes the response}
   → Result should {be identical to pre-change behavior OR gracefully handle new fields}

**Satisfaction criteria:**
- Consumer does not error, crash, or produce wrong results
- No data loss or corruption at the boundary
- Performance within acceptable bounds

**Adversarial variant:** {Consumer sends old-format request / ignores new required field / times out}

---

## Scoring Summary

{Fill in after validation run}

| Scenario | Satisfied | Partially | Not Satisfied | Notes |
|----------|-----------|-----------|---------------|-------|
| S1 | | | | |
| S2 | | | | |
| **Total** | **/N** | **/N** | **/N** | **Target: 90%+** |
