#!/bin/sh
set -eu
cd /var/minis/shared/github/chatgpt-test

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "ERROR: GITHUB_TOKEN is not set."
  exit 2
fi

msg="${1:-Minis auto update}"

git config user.name "Minis Bot"
git config user.email "minis@local.device"

git add -A
if git diff --cached --quiet; then
  echo "No changes to upload."
  exit 0
fi

git commit -m "$msg"

git remote set-url origin "https://a01059299935-glitch:${GITHUB_TOKEN}@github.com/a01059299935-glitch/chatgpt-test.git"
git push origin main
git remote set-url origin "https://github.com/a01059299935-glitch/chatgpt-test.git"

echo "Uploaded to GitHub."
