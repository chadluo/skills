#!/bin/sh
# Link every skill in this repo into the Codex (~/.agents) and Claude Code (~/.claude) skill directories.
# Edits in this repo are then live in both agents. Real directories are never replaced; remove them first.
set -eu
repo=$(cd "$(dirname "$0")" && pwd)
for skill in "$repo"/skills/*/; do
  skill=${skill%/}
  name=$(basename "$skill")
  for dir in "$HOME/.agents/skills" "$HOME/.claude/skills"; do
    mkdir -p "$dir"
    target="$dir/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "skip $target: real directory, remove it first" >&2
      continue
    fi
    ln -sfn "$skill" "$target"
    echo "$target -> $skill"
  done
done
