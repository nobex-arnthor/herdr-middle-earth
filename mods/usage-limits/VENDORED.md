Vendored from https://github.com/VladTemp27/herdr-mods/tree/4f6d54e3737e0ef7629c49c3da1145832e471b34/usage-limits
(Apache-2.0, see LICENSE and NOTICE). To update: copy that folder's mods/usage-limits over this one, keeping this file
and re-applying the changes below.

Changes:
- helpers/claude-usage.sh and helpers/codex-limits.sh: feeds the CLI through a plain pipe instead of a FIFO, so it also works under
  Git Bash on Windows (MSYS FIFOs don't reach native Windows programs). Same request, same output.
