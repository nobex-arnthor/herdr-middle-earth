#!/bin/sh
# Prints Claude Code's usage (one `control_response` JSON line) and exits.
#
# Runs your own `claude` CLI briefly and sends it the `get_usage` control
# request; the CLI authenticates itself. This script reads no tokens or
# credential files, sends no prompt and starts no turn. `--safe-mode` keeps
# hooks, MCP servers and customizations out of it.
# Approach credit: Joseph Malicki's jmalicki/herdr-mod-ai-usage (MIT), whose
# collector asks the claude CLI for usage this way. No code is copied from it.
#
# Exit: 0 = printed the reply, 127 = claude CLI not found, 1 = no reply in 15 s.
# Override the binary with HERDR_USAGE_CLAUDE_BIN.

CLAUDE=$(command -v "${HERDR_USAGE_CLAUDE_BIN:-claude}" 2>/dev/null) || exit 127

dir=$(mktemp -d "${TMPDIR:-/tmp}/herdr-claude-usage.XXXXXX") || exit 1
out="$dir/out"
: >"$out"

# A plain pipe, not a FIFO: MSYS FIFOs don't reach native Windows programs.
# The writer keeps stdin open until the reply lands (max 15 s), then closes it
# and the CLI exits on EOF.
{
  printf '%s
' '{"type":"control_request","request_id":"herdr-usage-limits","request":{"subtype":"get_usage","skip_behaviors":true}}'
  i=0
  while [ "$i" -lt 75 ] && ! grep -q '"control_response"' "$out" 2>/dev/null; do
    sleep 0.2
    i=$((i + 1))
  done
} | "$CLAUDE" -p --safe-mode --no-session-persistence   --input-format stream-json --output-format stream-json --verbose   >"$out" 2>/dev/null

status=1
if grep -m1 '"control_response"' "$out"; then status=0; fi
rm -rf "$dir"
exit $status
