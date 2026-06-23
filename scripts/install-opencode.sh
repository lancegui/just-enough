#!/usr/bin/env bash
#
# install-opencode.sh — install the just-enough skill into OpenCode.
#
# OpenCode (>= 1.x) auto-discovers skills from
#   ~/.config/opencode/skills/<name>/SKILL.md
# This script SYMLINKS just-enough's skill there, so repo edits stay live and
# the installed skill can never drift stale (a copy would). Idempotent — re-run
# any time. Restart OpenCode (or run /skills) afterward to load the change.
#
#   ./scripts/install-opencode.sh                 # symlink into ~/.config/opencode/skills
#   ./scripts/install-opencode.sh --copy          # copy instead of symlink
#   OPENCODE_CONFIG=/path ./scripts/install-opencode.sh   # non-default config dir
#   ./scripts/install-opencode.sh --uninstall     # remove the installed skill
#
# Requires: bash. Works from a local clone.
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
skill_src="$repo_root/skills/just-enough"
[ -f "$skill_src/SKILL.md" ] || { echo "error: $skill_src/SKILL.md not found — run from the just-enough clone" >&2; exit 1; }

cfg="${OPENCODE_CONFIG:-$HOME/.config/opencode}"
dest="$cfg/skills/just-enough"

if [ "${1:-}" = "--uninstall" ]; then
  rm -rf "$dest"
  echo "removed $dest — restart OpenCode (or /skills) to drop the skill."
  exit 0
fi

mkdir -p "$cfg/skills"

if [ "${1:-}" = "--copy" ]; then
  rm -rf "$dest"
  cp -R "$skill_src" "$dest"
  echo "copied skill → $dest"
else
  ln -sfn "$skill_src" "$dest"
  echo "symlinked skill → $dest -> $skill_src"
fi

# sanity: the skill's SKILL.md is reachable through the destination
if grep -q '^name: just-enough$' "$dest/SKILL.md" 2>/dev/null; then
  echo "ok: SKILL.md readable. Restart OpenCode (or run /skills) to load 'just-enough'."
else
  echo "warning: SKILL.md not readable at $dest/SKILL.md" >&2
  exit 1
fi
