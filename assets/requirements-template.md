---
document_type: requirements
project_id: {PROJECT_ID}
version: 1.0.0
last_updated: {TIMESTAMP}
status: draft
shapiro_level: 4  # 2=fix | 3=minor | 4=feature | 5=system
---

# {Project Name} — Product Requirements Document

## Executive Summary

{2-3 paragraphs: what we're building, why it matters, key design philosophy. This should flow directly from the Discovery Summary.}

---

## Open Questions

**GATE: All Critical questions must be resolved before feature specs are finalized. The spec is not ready for implementation while Critical questions remain.**

### Critical (blocks spec)

- [ ] {question — must resolve before writing features}

### High (blocks implementation)

- [ ] {question — must resolve before coding starts}

### Deferred (parking lot)

- [ ] {question — resolve later, does not block}

---

## Discovery Summary

{Paste or synthesize from the interview protocol output. This section provides traceability from intent to spec.}

**Problem:** {1-2 sentences — the pain, who feels it, how often}

**Success Criteria:**
- {Measurable outcome 1}
- {Measurable outcome 2}

**Scope Boundaries (What This Is NOT — project-wide):**
- NOT {exclusion 1}
- NOT {exclusion 2}

**Key Stakeholders:** {who uses it, who approves it, who's affected}

**Constraints:** {tech, time, team, compliance}

**Validation Approach:** {how we'll know it works — links to SCENARIOS.md}

---

## System Context & Impact Analysis

{What does this change touch? Trace the blast radius before specifying features.}

### Components Affected

| Component | Type | What Changes | Owner |
|-----------|------|-------------|-------|
| {id/name} | {service/module/agent/flow/object} | {added/modified/consumed differently} | {team/person} |

### Contracts Affected

| Contract | Component | Change Type | Breaking? | Consumers Impacted |
|----------|-----------|------------|-----------|-------------------|
| {contract_id} | {component} | {new field / changed type / new contract} | {yes/no} | {list of consumers} |

### Blast Radius Summary

- **Components directly modified:** {N}
- **Contracts affected:** {N}
- **Downstream consumers impacted:** {N}
- **Breaking changes:** {N} — each has a migration path in the feature specs below

{Reference SYSTEM_MAP.yaml if it exists. If it doesn't exist for this area, create it as a deliverable of this spec.}

---

## F1: {Feature Title}

### Problem Statement

{1-2 paragraphs. What's broken / missing and why it matters. Reference the Discovery Summary.}

### Evidence

{Exact file paths, line numbers, code snippets, DB query results, stakeholder quotes, market data — whatever is relevant.}

```text
file.ts:137 — criteria.skills.required.join(', ')
// This renders [object Object] when skills contain rich objects
```

### Impact Analysis

{Per-feature impact — which components and contracts does THIS feature touch?}

| Consumer | Depends On | Impact | Action Required |
|----------|-----------|--------|-----------------|
| {component} | {contract/interface} | {breaking / compatible / none} | {update / test / nothing} |

### Functional Requirements

| ID | Requirement | Priority |
|----|------------|----------|
| F1-01 | {requirement} | P0 |
| F1-02 | {requirement} | P1 |

### Technical Specification

{Exact code changes, types, interfaces, schemas, API contracts, contract changes. For features, this may be architectural rather than line-level.}

```typescript
// BEFORE:
criteria.skills.required.join(', ')

// AFTER:
toSkillNames(criteria.skills.required).join(', ')
```

**Contract changes (if any):**

```yaml
# {contract_id} — version bump from X to Y
# Added field:
- name: {field}
  type: {type}
  required: {true/false}
```

### Acceptance Scenarios

{These are VISIBLE to the implementer. They define "what does correct behavior look like."}

```gherkin
GIVEN {initial state}
  AND {additional context}
WHEN {action}
THEN {expected outcome}
  AND {additional verification}
```

### Edge Cases

| Case | Expected Behavior |
|------|-------------------|
| {null input} | {behavior} |
| {empty array} | {behavior} |
| {mixed types} | {behavior} |
| {contract consumer sends old format} | {behavior — backward compat} |

### What This Is NOT

- NOT {explicit exclusion 1}
- NOT {explicit exclusion 2}

---

{Repeat for F2, F3, ...}

---

## Non-Functional Requirements

### Performance

| Requirement | Target |
|-------------|--------|
| {feature} | {target} |

### Security

- {security consideration}

### Backward Compatibility

- {compat note — especially for contract changes}
- {deprecation timeline for breaking changes}

### Observability

- {what we monitor post-ship}
- {alerts / dashboards needed}
- {contract violation detection}

---

## Deliverables Checklist

- [ ] REQUIREMENTS.md (this document)
- [ ] SCENARIOS.md (holdout validation)
- [ ] IMPLEMENTATION_PLAN.md (phased tasks + convergence)
- [ ] DECISIONS.md (ADRs)
- [ ] SYSTEM_MAP.yaml (new or updated)
- [ ] contracts/ (new or updated boundary contracts)

---

## Appendix: Null Handling Contract

| Field | null | 0 | "" | unknown | outlier |
|-------|------|---|----|---------|---------|
| {field} | {behavior} | {behavior} | {behavior} | {behavior} | {behavior} |

**Rule: Missing data NEVER scores 0. Unknown = neutral.**
