# Evidence Gathering Protocol

Before writing any spec document, gather concrete evidence for every claim. Choose the path that matches the work type.

## Path A: Code-Level Evidence (Fixes, Refactors)

For work where the problem is observable in code or data.

### Step A1: Codebase Evidence

For each affected feature, find:

```bash
# Find the exact lines where the problem lives
grep -rn "functionName\|variableName" src/ --include="*.ts" | head -20

# Read the exact code at the flagged location
sed -n '130,150p' src/path/to/file.ts
```

Record: **file path : line number : exact code snippet : what's wrong**

### Step A2: Live Data Evidence

Write and run a diagnostic script:

```typescript
// scripts/diagnose-{feature}.ts
const result = await session.run(`
  MATCH (n:NodeType) WHERE condition
  RETURN n.field, count(*) as cnt
  ORDER BY cnt DESC LIMIT 20
`);
```

Run with: `doppler run --project X --config dev -- npx tsx scripts/diagnose-{feature}.ts`

Record: **query : result count : sample data : what it proves**

### Step A3: Impact Scope

```bash
# Find all callers of the affected function/type
grep -rn "FunctionName\|TypeName" src/ --include="*.ts" | wc -l

# Find all routes that use the affected shared utility
grep -rn "import.*{.*functionName" src/app/api/ --include="*.ts"
```

Record: **N files affected : N routes affected : list of route paths**

### Step A4: Current vs Expected Behavior

```text
CURRENT: When skills.required = [{name:"Python", minProficiency:"Expert"}],
         the intelligence prompt shows "Search: [object Object]"

EXPECTED: The intelligence prompt should show "Search: Python"
```

---

## Path B: Context-Level Evidence (Features, Systems)

For work where the problem isn't observable in code — it lives in conversations, documents, market conditions, or stakeholder heads.

### Step B1: Stakeholder Evidence

Gather direct quotes and statements from the people who feel the pain:

| Source | Statement | Date | Implication |
|--------|-----------|------|-------------|
| {Person/Channel} | "{direct quote or paraphrase}" | {when} | {what this tells us} |

Sources: Slack threads, meeting notes, customer calls, support tickets, interviews.

Tools: Use `conversation_search` for prior conversations. Use Slack search for channel history. Check uploaded documents.

### Step B2: Market & Competitive Evidence

Research what exists externally:

| Competitor/Tool | What They Do | Gap/Opportunity |
|----------------|--------------|-----------------|
| {name} | {capability} | {what we'd do differently} |

Tools: Use `web_search` for competitive landscape. Check industry reports, analyst content.

### Step B3: System & Architecture Evidence

Map the existing system landscape the feature will touch:

| System | Role | Integration Point | Owner |
|--------|------|-------------------|-------|
| {system} | {what it does} | {API/DB/event} | {team/person} |

Tools: Check architecture docs, Lucidchart diagrams, README files. Use relevant MCP tools (Salesforce, Google Drive, etc.) to inspect current state.

### Step B4: Usage & Data Evidence

Quantify the current state:

| Metric | Current Value | Source | What It Means |
|--------|--------------|--------|---------------|
| {metric} | {value} | {where from} | {so what} |

Sources: Analytics dashboards, database queries, API logs, user surveys.

### Step B5: Prior Art Evidence

Document what's been tried:

| Attempt | When | Outcome | Why It Failed/Succeeded |
|---------|------|---------|------------------------|
| {approach} | {date} | {result} | {root cause} |

Sources: Old PRDs, archived Slack threads, git history, conversation history.

---

## Evidence Quality Checklist

### For Fixes (Path A)
- [ ] Every problem has a file:line reference
- [ ] Data claims backed by actual DB query results
- [ ] Impact scope quantified (N files, N routes)
- [ ] Current behavior documented with exact output
- [ ] Expected behavior specified unambiguously

### For Features/Systems (Path B)
- [ ] Problem validated by at least 2 stakeholder sources
- [ ] Market context researched (not just internal assumptions)
- [ ] System dependencies mapped with integration points
- [ ] Current state quantified where possible
- [ ] Prior attempts documented (or confirmed none exist)

### Universal
- [ ] No claim rests on assumption alone
- [ ] Evidence is dated (context decays)
- [ ] Sources are cited (not "someone said")
