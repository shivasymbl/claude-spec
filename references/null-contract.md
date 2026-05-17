# Null Handling Contract Template

Every spec that touches data with nullable fields MUST include a null handling table.

## Template

```markdown
## Null Handling Contract

| Field | null/undefined | 0 | empty string | unknown value | outlier (>max) |
|-------|---------------|---|-------------|---------------|----------------|
| field_name | [behavior] | [behavior] | [behavior] | [behavior] | [behavior] |
```

## Rules

1. **Missing data NEVER scores 0** — use a neutral value (0.3-0.6 range)
2. **0 is ambiguous** for numeric fields — treat as "not provided" unless explicitly meaningful
3. **Empty string** is treated the same as null
4. **Unknown enum values** map to neutral (not the lowest value)
5. **Outliers** are clamped, not rejected (e.g., years > 40 → clamp to 40)

## Scoring Neutrality Scale

```text
0.0 ─── Penalized (wrong answer)
0.2 ─── Low (confirmed weak signal)
0.3 ─── Soft neutral (location unknown)
0.5 ─── Mid neutral (skill proficiency unknown)
0.6 ─── High neutral (benefit of the doubt)
0.8 ─── Strong signal
1.0 ─── Perfect match
```

## Example: Candidate Search

```markdown
| Field | null | 0 | "" | unknown | > 40 |
|-------|------|---|----|---------|------|
| proficiency_level | 0.6 (neutral) | N/A | 0.6 | 0.6 | N/A |
| years_of_experience | skip dimension | null (ambiguous) | N/A | N/A | clamp 40 |
| location (city) | 0.3 (neutral) | N/A | 0.3 | N/A | N/A |
| education degree | skip record | N/A | skip record | N/A | N/A |
| contact_summary | skip (no penalty) | N/A | skip | N/A | N/A |
```
