#!/usr/bin/env bash
# Regenerate every placeholder asset for the Electric Scooter mod.
# Run from anywhere; resolves paths relative to this script.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
echo "== Textures =="
python3 "$HERE/gen_textures.py"
echo
echo "== Posters + icons =="
python3 "$HERE/gen_poster.py"
echo
echo "== Sounds =="
python3 "$HERE/gen_sounds.py"
echo
echo "== FBX placeholder =="
python3 "$HERE/gen_fbx.py"
echo
echo "Done."
