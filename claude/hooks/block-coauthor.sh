#!/bin/bash
# Block any git commit that contains Co-Authored-By
# Receives tool input via stdin as JSON

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | grep -o '"command":"[^"]*"' | head -1)

if echo "$COMMAND" | grep -qi "co-authored-by"; then
  echo "BLOCKED: Co-Authored-By is not allowed in commits." >&2
  exit 2
fi

exit 0
