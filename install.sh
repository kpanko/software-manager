#!/usr/bin/env bash
# Installs the session management commands into ~/.claude/commands/
# so they're available as slash commands in any CC project.
# Removes any previously installed commands that no longer exist.

set -e

COMMANDS_DIR="$HOME/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$COMMANDS_DIR"

# Remove installed commands that no longer exist in source
for installed in "$COMMANDS_DIR/"*.md; do
    [ -f "$installed" ] || continue
    name="$(basename "$installed")"
    if [ ! -f "$SCRIPT_DIR/commands/$name" ]; then
        rm "$installed"
        echo "Removed:   $COMMANDS_DIR/$name"
    fi
done

# Install current commands
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
