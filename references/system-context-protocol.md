# System Context Protocol: Map Before You Modify

Before specifying a change to any system, you must understand the system you're changing. This protocol establishes three living artifacts that keep specs grounded in reality as a system evolves.

## When to Use

- Any spec that modifies an existing system (not greenfield v1)
- Any spec where components communicate across boundaries (APIs, events, shared state, imports)
- Any spec where "what breaks if I change this?" is a non-trivial question

## When to Skip

- True greenfield with no existing code (but CREATE the artifacts as part of the spec)
- Isolated cosmetic changes with no interface impact (copy changes, CSS tweaks)

---

## The Three Artifacts

### 1. System Map

A machine-readable description of what exists: components, their responsibilities, and how they connect. Think of it as the dependency graph for your system.

**Applies to any architecture:**

| Architecture Style | Components | Connections |
|-------------------|------------|-------------|
| Monolith | Modules, classes, services | Function calls, imports, shared state |
| Microservices | Services, APIs | HTTP calls, events, queues |
| Pipeline / ETL | Stages, transforms | Data flow, schemas |
| Frontend | Components, pages, stores | Props, context, state, API calls |
| Salesforce | Objects, flows, triggers, classes | Field references, flow inputs, SOQL |
| Multi-agent | Agents, tools, workflows | MCP calls, handoffs, shared memory |
| n8n / workflow | Nodes, sub-workflows | Connections, webhook triggers, shared data |

**Format** (adapt to your system — YAML, JSON, or even a well-structured markdown):

```yaml
system: {system_name}
version: {semver or date}
last_updated: {timestamp}

components:
  - id: {unique_id}
    name: {human_readable_name}
    type: {service | module | component | agent | flow | object | stage}
    responsibility: {what it does in one line}
    owner: {team or person}
    interfaces:
      publishes:
        - id: {interface_id}
          type: {api | event | schema | props | field | export}
          contract: {path to contract definition}
      consumes:
        - interface_id: {id from another component's publishes}
          component_id: {which component}
```

**The key rule: every boundary between components should be visible in the map.** If component A talks to component B, that relationship is explicit — not buried in code that only grep can find.

### 2. Boundary Contracts

A contract defines what crosses a boundary: the shape, the guarantees, and the versioning. Every published interface in the system map should have a contract.

**Contracts vary by boundary type:**

| Boundary Type | Contract Defines | Example |
|--------------|-----------------|---------|
| REST API | Request/response schemas, status codes, auth | OpenAPI / Swagger spec |
| Event / Message | Event payload schema, ordering guarantees | AsyncAPI / JSON Schema |
| Data pipeline | Input/output schemas per stage | JSON Schema, dbt manifest |
| Component props | Prop types, required vs optional, defaults | TypeScript interfaces, PropTypes |
| Salesforce object | Fields, types, required, validation rules | Object metadata XML |
| Function / module | Parameters, return types, side effects | TypeScript types, JSDoc |
| Agent handoff | Input context, expected output, tool access | Prompt contract (natural language + schema) |

**Contract template (generic):**

```yaml
contract:
  id: {unique_id}
  component: {component_id}
  version: {semver}
  type: {api | event | schema | props | handoff}
  
  # What this boundary accepts
  input:
    required_fields:
      - name: {field}
        type: {type}
        description: {what it is}
    optional_fields:
      - name: {field}
        type: {type}
        default: {value}
  
  # What this boundary produces
  output:
    fields:
      - name: {field}
        type: {type}
        nullable: {true/false}
        description: {what it is}
  
  # Who depends on this
  consumers:
    - component_id: {id}
      fields_used: [{which fields the consumer actually reads}]
  
  # What must not break
  guarantees:
    - {e.g., "field X is always present when status = active"}
    - {e.g., "response time < 200ms at p95"}
  
  # Compatibility rules
  evolution:
    allowed: [add_optional_field, deprecate_field_with_warning]
    forbidden: [remove_field, change_type, rename_field]
```

**The key rule: you can't change a contract without updating all consumers.** If you add a required field, every consumer must handle it. If you change a type, every consumer must adapt.

### 3. Impact Analysis

Before writing the spec, trace the blast radius of your proposed change through the system map and contracts.

**Impact analysis template:**

```markdown
## Change Impact Analysis

### Proposed Change
{What are we changing, at which component}

### Direct Impact (components we're modifying)
| Component | What Changes | Contract Affected |
|-----------|-------------|-------------------|
| {id} | {description} | {contract_id} |

### Downstream Impact (consumers of what we're changing)
| Consumer | Depends On | Impact | Action Required |
|----------|-----------|--------|-----------------|
| {id} | {contract_id} | {breaking / compatible / none} | {update / test / nothing} |

### Upstream Impact (producers we consume differently)
| Producer | We Consume | Impact | Action Required |
|----------|-----------|--------|-----------------|
| {id} | {contract_id} | {new dependency / changed usage / none} | {update / negotiate / nothing} |

### Transitive Impact (consumers of our consumers, if breaking)
| Component | Path | Impact |
|-----------|------|--------|
| {id} | {A → B → C} | {description} |

### Blast Radius Summary
- **Components directly modified:** {N}
- **Contracts affected:** {N}
- **Downstream consumers impacted:** {N}
- **Breaking changes:** {N} — each requires explicit migration
- **Compatible changes:** {N} — consumers unaffected
```

**The key rule: the spec must include every impacted component in its scope.** If your change breaks 3 downstream consumers, those 3 fixes are part of your spec — not separate tickets discovered in production.

---

## How This Integrates with the Spec Process

### During Evidence Gathering (Step 2)
- Read the system map (if it exists)
- Identify the components your change touches
- Pull the relevant boundary contracts

### Before Writing the Spec (new Step 2.5: Map System Context)
- If no system map exists for this area, create one as part of the spec
- Run the impact analysis
- Include all impacted components in the spec scope

### In the Requirements (REQUIREMENTS.md)
- Include the Impact Analysis section
- Every feature's scope must account for downstream changes
- Contract changes are explicit requirements, not afterthoughts

### In Holdout Scenarios (SCENARIOS.md)

- Include regression scenarios for every consumer of a changed contract
- "Does the thing that used to work still work?" is a first-class scenario

### After Implementation (manifest maintenance)

- Update the system map to reflect the new state
- Version the changed contracts
- This is a required step in the implementation plan, not optional cleanup

---

## Creating System Context for Existing Projects

If you're speccing against a codebase that doesn't have these artifacts yet, build them incrementally:

1. **Start with the components your spec touches** — don't try to map the whole system
2. **Trace one level out** — direct producers and consumers of what you're changing
3. **Document the contracts that exist in code** — extract interfaces, schemas, types from the actual codebase
4. **Commit the artifacts alongside the spec** — they're part of the deliverable

Over time, each spec adds to the system map. After a few specs, you have comprehensive coverage of the areas that actually change.

---

## Anti-Patterns

- **Mapping the whole system upfront.** Only map what the current spec touches + one level out. Comprehensive maps rot.
- **Treating the map as documentation.** It's a tool for the agent/implementer, not a pretty diagram for humans. Machine-readable > human-readable.
- **Skipping impact analysis for "small" changes.** The scariest production incidents come from "small" changes that had invisible downstream effects.
- **Updating code but not contracts.** If you change an API response shape and don't update the contract, the contract is now a lie. Lies in contracts are worse than no contracts.
- **Separate tickets for downstream fixes.** If your change breaks a consumer, fixing that consumer is part of YOUR spec, not a follow-up ticket. Ship the change and its consequences together.
