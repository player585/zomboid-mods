#!/bin/bash
# Run this once from inside the zomboid-mods folder
# to initialize git and push to your GitHub account.
# Make sure you have git installed and are logged in via gh CLI or SSH key.

GITHUB_USER="carswell585"
REPO_NAME="zomboid-mods"

echo "==> Initializing git repo..."
git init
git add .
git commit -m "Initial commit: zomboid-mods repo with Electric Scooter v1.0.0"

echo "==> Creating GitHub repo (requires gh CLI — https://cli.github.com)..."
gh repo create "$GITHUB_USER/$REPO_NAME" \
  --public \
  --description "Project Zomboid mods by carswell585 — Build 41 + 42 compatible" \
  --source=. \
  --remote=origin \
  --push

echo "==> Done! Repo live at: https://github.com/$GITHUB_USER/$REPO_NAME"
