#!/usr/bin/env bash
# Installs the session management commands into ~/.claude/commands/
# so they're available as slash commands in any CC project.

set -e

COMMANDS_DIR="$HOME/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$COMMANDS_DIR"

for cmd in "$SCRIPT_DIR/commands/"*.md; do
    name="$(basename "$cmd")"
    dest="$COMMANDS_DIR/$name"
    cp "$cmd" "$dest"
    echo "Installed: $dest"
done

echo ""
echo "Done. Commands available in Claude Code:"
for cmd in "$SCRIPT_DIR/commands/"*.md; do
    name="$(basename "$cmd" .md)"
    echo "  /$name"
done
