# Interview Protocol: Discovering Intent Before Spec

This protocol extracts the understanding needed to write an executable spec. It replaces assumptions with confirmed intent.

## When to Use

- New feature or capability (no existing code to grep)
- System design or architecture work
- Work where the context lives in someone's head, not in a codebase
- Any time you're uncertain about what "done" looks like

## When to Skip

- Bug fix with observable symptoms (go straight to evidence gathering)
- Refactor with clear before/after (go straight to evidence gathering)
- The user has already provided a complete, detailed brief

## The Question Set

Questions are grouped by priority. Ask Critical questions first. If time is limited, High questions next. Medium and Low can become Open Questions in the spec.

### Critical (must answer before writing any spec)

| # | Question | What It Unlocks |
|---|----------|-----------------|
| C1 | **What problem are we solving?** Describe the pain, not the solution. Who feels this pain? How often? | Problem Statement, Executive Summary |
| C2 | **What does success look like?** If this ships and works perfectly, what's different? Give me a measurable outcome. | Acceptance criteria, convergence criteria |
| C3 | **What is this NOT?** What are we explicitly not building, even if someone might expect it? | "What This Is NOT" section per feature |
| C4 | **Who are the users/stakeholders?** Who uses it? Who approves it? Who gets affected by it? | Stakeholder map, review gates |

### High (should answer before writing feature specs)

| # | Question | What It Unlocks |
|---|----------|-----------------|
| H1 | **What's been tried before?** Prior approaches, failed attempts, existing workarounds. Why didn't they work? | Evidence section, ADR alternatives |
| H2 | **What are the constraints?** Tech stack, timeline, budget, team capacity, compliance, integrations. | Non-functional requirements, implementation phasing |
| H3 | **What systems does this touch?** Databases, APIs, external services, other teams' code. | Dependency map, environment spec, DTU needs |
| H4 | **How will we validate this works?** Not just "tests pass" — how would a real user confirm satisfaction? | Scenario design, holdout validation |

### Medium (good to answer, can defer to Open Questions)

| # | Question | What It Unlocks |
|---|----------|-----------------|
| M1 | **What's the rollout strategy?** Big bang? Phased? Feature flag? Who gets it first? | Implementation phasing, risk mitigation |
| M2 | **What happens if it fails?** Rollback plan? Degraded mode? Who gets paged? | Edge cases, observability requirements |
| M3 | **What data do we need?** Existing data? New data sources? Data quality concerns? | Data model, ETL requirements, null contracts |
| M4 | **What does the team need to learn?** New tech? New domain knowledge? Training? | Ramp-up time in implementation plan |

### Low (nice to have, often deferred)

| # | Question | What It Unlocks |
|---|----------|-----------------|
| L1 | **What's the long-term vision?** Where does this go in 6-12 months? | Architecture decisions, extensibility |
| L2 | **What would make this 10x better?** If no constraints existed, what's the dream version? | Future roadmap, Phase 2+ scoping |
| L3 | **Who else should we talk to?** Are there subject matter experts, customers, partners with relevant input? | Additional discovery, stakeholder map |

## How to Run the Interview

### Interactive Mode (human present, e.g., Claude.ai or Claude Code)

1. **Don't machine-gun questions.** Ask 2-3 per turn, grouped logically.
2. **Start with C1 + C2** — these unlock everything else.
3. **Listen for implicit answers.** The user often answers H1-H3 while explaining C1. Don't re-ask what's already been said.
4. **Use bounded choices when possible.** If you can infer 2-4 options, present them as choices rather than open-ended questions.
5. **Synthesize after each turn.** "So what I'm hearing is..." — confirm understanding before moving on.
6. **Stop when you have enough.** Not every question needs an answer. If you can write the Executive Summary confidently, you're ready.

**Typical flow: 2-4 turns of conversation, 5-10 minutes.**

### Async Mode (from documents, Slack threads, prior conversations)

1. Extract answers from available context (uploaded docs, conversation history, memory).
2. Map each extracted answer to the question it answers.
3. Flag unanswered Critical questions as blockers.
4. Flag unanswered High questions as Open Questions.
5. Present the Discovery Summary and ask for confirmation + gap-filling.

### From Existing PRD/Brief

1. Read the document.
2. Map its content to the question set — what's answered, what's missing?
3. Present gaps as questions back to the user.
4. Most PRDs answer C1 and C4 well but are weak on C3 (what it's NOT) and H4 (validation approach).

## Output: Discovery Summary

After the interview, synthesize into this block. This feeds directly into the spec.

```markdown
## Discovery Summary

**Problem:** {1-2 sentences — the pain, who feels it, how often}

**Success Criteria:**
- {Measurable outcome 1}
- {Measurable outcome 2}

**Scope Boundaries (What This Is NOT):**
- NOT {exclusion 1}
- NOT {exclusion 2}

**Key Stakeholders:** {who uses it, who approves it, who's affected}

**Constraints:** {tech, time, team, compliance}

**Dependencies:** {systems, services, data sources}

**Validation Approach:** {how we'll know it works beyond "tests pass"}

**Open Questions (Critical):**
- [ ] {must resolve before spec}

**Open Questions (High):**
- [ ] {should resolve before implementation}

**Open Questions (Deferred):**
- [ ] {parking lot — resolve later}
```

## Anti-Patterns

- **Writing the spec first, then asking questions.** The spec should emerge from discovery, not precede it.
- **Assuming you know the answer.** Even if you have context from memory or prior conversations, confirm with the user. Context decays.
- **Asking all 15 questions sequentially.** Read the room. If the user gives a rich initial brief, skip to the gaps.
- **Treating the interview as a form to fill out.** It's a conversation. Follow the thread. The best insights come from follow-up questions, not the scripted list.
- **Stopping at "what do you want?"** The critical question is C2 — what does success look like? Most people can describe what they want. Few can articulate what "done" means.
