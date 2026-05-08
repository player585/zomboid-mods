#!/usr/bin/env bash
# new-mod.sh — scaffold a new Project Zomboid mod inside this repo.
#
# Usage:
#   scripts/new-mod.sh <mod-folder-name> <ModId> "Display Name"
#
# Example:
#   scripts/new-mod.sh fishing-overhaul FishingOverhaul "Fishing Overhaul"
#
# Creates the full Build 41 + Build 42 folder layout, mod.info files,
# workshop.txt, README.md stub, and a placeholder Core.lua. Safe to re-run:
# refuses to overwrite existing folders.

set -euo pipefail

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <mod-folder-name> <ModId> \"Display Name\""
    exit 64
fi

FOLDER="$1"
MODID="$2"
DISPLAY="$3"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$REPO_ROOT/$FOLDER"

if [ -e "$TARGET" ]; then
    echo "Refusing to overwrite existing folder: $TARGET"
    exit 1
fi

echo "Creating $TARGET"
mkdir -p "$TARGET/Contents/mods/$MODID/common/media/lua/shared"
mkdir -p "$TARGET/Contents/mods/$MODID/common/media/lua/client"
mkdir -p "$TARGET/Contents/mods/$MODID/common/media/lua/server"
mkdir -p "$TARGET/Contents/mods/$MODID/common/media/scripts"
mkdir -p "$TARGET/Contents/mods/$MODID/common/media/textures"
mkdir -p "$TARGET/Contents/mods/$MODID/common/media/models"
mkdir -p "$TARGET/Contents/mods/$MODID/common/media/sound"
mkdir -p "$TARGET/Contents/mods/$MODID/41"
mkdir -p "$TARGET/Contents/mods/$MODID/42"

cat > "$TARGET/Contents/mods/$MODID/42/mod.info" <<EOF
name=$DISPLAY
id=$MODID
description=$DISPLAY for Project Zomboid Build 42.
poster=poster.png
icon=icon.png
url=https://github.com/player585/zomboid-mods
authors=player585, zmodder
modversion=0.1.0
pzversion=42.0.0
tags=Build 42
require=
EOF

cat > "$TARGET/Contents/mods/$MODID/41/mod.info" <<EOF
name=$DISPLAY
id=$MODID
description=$DISPLAY for Project Zomboid Build 41.
poster=poster.png
icon=icon.png
url=https://github.com/player585/zomboid-mods
authors=player585, zmodder
modversion=0.1.0
pzversion=41.78.16
tags=Build 41
require=
EOF

cat > "$TARGET/workshop.txt" <<EOF
version=1
id=0
title=$DISPLAY
description=Steam Workshop description for $DISPLAY goes here.
tags=Build 42;Build 41
visibility=public
EOF

cat > "$TARGET/README.md" <<EOF
# $DISPLAY — Project Zomboid Mod
**Version:** 0.1.0
**Compatible:** Build 41 + Build 42
**Author:** player585

## Features
- TODO

## Installation
See the [root README](../README.md#how-to-install-a-mod).

## Workshop
Not yet published. \`workshop.txt\` has \`id=0\` until upload.
EOF

cat > "$TARGET/Contents/mods/$MODID/common/media/lua/shared/${MODID}_Core.lua" <<EOF
-- ============================================================
--  ${MODID}_Core.lua
--  Shared constants / utility functions for $DISPLAY.
-- ============================================================

$MODID = $MODID or {}

-- Add shared constants here. Example:
-- $MODID.SOME_CONSTANT = 42
EOF

# Add the new mod to root README mod table
README="$REPO_ROOT/README.md"
if [ -f "$README" ] && ! grep -q "$FOLDER" "$README"; then
    awk -v line="| [$DISPLAY](./$FOLDER) | TODO description | 🚧 WIP v0.1.0 | 41 + 42 |" '
        /^\| \[⚡ Electric Scooter\]/ { print; print line; next }
        { print }
    ' "$README" > "$README.tmp" && mv "$README.tmp" "$README"
fi

echo
echo "✅ Scaffolded $DISPLAY at $TARGET"
echo
echo "Next steps:"
echo "  1. Edit $TARGET/README.md and replace TODOs"
echo "  2. Add Lua/scripts under Contents/mods/$MODID/common/media/"
echo "  3. Drop assets in textures/, models/, sound/"
echo "  4. git add . && git commit -m 'Add $DISPLAY scaffold' && git push"
