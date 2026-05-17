#!/usr/bin/env bash
# PreToolUse hook — optional gate: blocks Write/Edit without approved spec
# Install: add to your project's .claude/settings.json hooks section
# This is OPTIONAL — governance decision per project
# Override: set CLAUDE_SPEC_BYPASS=1 in your environment to skip

set -euo pipefail

# Skip if bypass is set
[[ "${CLAUDE_SPEC_BYPASS:-}" == "1" ]] && exit 0

# Only gate on source code file writes (not spec artifacts themselves)
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"
FILE_PATH=$(echo "$TOOL_INPUT" | python3 -c "
import json,sys
try:
    d=json.loads(sys.stdin.read() or '{}')
    print(d.get('file_path', d.get('path','')))
except:
    print('')
" 2>/dev/null || echo "")

# Skip if no file path, writing to docs/spec/, or writing markdown
[[ -z "$FILE_PATH" ]] && exit 0
[[ "$FILE_PATH" == docs/spec/* ]] && exit 0
[[ "$FILE_PATH" == *.md ]] && exit 0
[[ "$FILE_PATH" == *.json ]] && exit 0
[[ "$FILE_PATH" == *.yaml ]] && exit 0
[[ "$FILE_PATH" == *.yml ]] && exit 0
# Shell scripts in docs/ or hooks/ are spec/config artifacts, not source code
[[ "$FILE_PATH" == docs/* && "$FILE_PATH" == *.sh ]] && exit 0
[[ "$FILE_PATH" == hooks/* && "$FILE_PATH" == *.sh ]] && exit 0
[[ "$FILE_PATH" == scripts/* && "$FILE_PATH" == *.sh ]] && exit 0

# Check for approved spec
# Use || echo 0 inside $() so pipefail or grep-no-match (exit 1) doesn't kill the script
APPROVED=$(find docs/spec/approved docs/spec/active -name "README.md" 2>/dev/null | \
  xargs grep -l "^status: approved" 2>/dev/null | wc -l | tr -d ' ' || echo 0)

if [ "${APPROVED:-0}" -eq 0 ]; then
  echo '{"decision":"block","reason":"No approved spec found. Run /claude-spec:plan and /claude-spec:approve before implementing source code. To bypass this gate, set CLAUDE_SPEC_BYPASS=1."}'
  exit 0
fi

exit 0
