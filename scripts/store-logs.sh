#!/bin/bash
# store-logs.sh — Commit this week's error logs to the error-logs branch.
#
# This script:
#   1. Creates a temporary clone of this repo
#   2. Checks out (or creates) the error-logs branch
#   3. Adds a dated directory with the error logs and report
#   4. Commits and pushes back to origin
#
# Requires GITHUB_TOKEN with contents:write permission.
# When running locally, uses the current git remote and credentials.
set -euo pipefail

DATE=$(date +%Y-%m-%d)
REPO_URL="${GITHUB_SERVER_URL:-https://github.com}/${GITHUB_REPOSITORY:-}"

# Files to archive
CORE_LOG="${1:-core_errors.txt}"
KERNEL_LOG="${2:-kernel_errors.txt}"
REPORT="${3:-report.md}"

# ── Determine repo URL with auth ─────────────────────────────────────────────
if [ -n "${GITHUB_TOKEN:-}" ] && [ -n "${GITHUB_REPOSITORY:-}" ]; then
    AUTH_REPO="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
elif [ -n "${GITHUB_REPOSITORY:-}" ]; then
    # In GitHub Actions without token fallback
    AUTH_REPO="https://github.com/${GITHUB_REPOSITORY}.git"
else
    # Running locally: use origin remote
    AUTH_REPO=$(git remote get-url origin 2>/dev/null || echo "")
    if [ -z "$AUTH_REPO" ]; then
        echo "ERROR: Cannot determine repo URL. Set GITHUB_REPOSITORY or run from a git repo."
        exit 1
    fi
fi

echo "=== Storing logs for $DATE to error-logs branch ==="

# ── Clone into temp directory ────────────────────────────────────────────────
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Cloning repo into $TEMP_DIR ..."

# Try to clone the error-logs branch
if ! git clone --branch error-logs --single-branch --depth=1 \
    "$AUTH_REPO" "$TEMP_DIR" 2>/dev/null; then
    echo "error-logs branch does not exist yet; creating it..."
    # Clone main branch shallow, then create orphan
    git clone --single-branch --depth=1 "$AUTH_REPO" "$TEMP_DIR" 2>/dev/null || {
        # Fallback: use local repo
        echo "Clone failed; using local repo as fallback..."
        git clone "$(git rev-parse --show-toplevel)" "$TEMP_DIR"
    }
    git -C "$TEMP_DIR" checkout --orphan error-logs
    git -C "$TEMP_DIR" rm -rf . 2>/dev/null || true
fi

# ── Copy files into dated directory ──────────────────────────────────────────
mkdir -p "$TEMP_DIR/$DATE"

for f in "$CORE_LOG" "$KERNEL_LOG" "$REPORT"; do
    if [ -f "$f" ]; then
        cp "$f" "$TEMP_DIR/$DATE/"
        echo "  Copied: $f"
    else
        echo "  Warning: $f not found, skipping"
    fi
done

# Write a metadata file
GCCRS_COMMIT="${GCCRS_COMMIT:-unknown}"
cat > "$TEMP_DIR/$DATE/metadata.json" << EOF
{
  "date": "$DATE",
  "gccrs_commit": "$GCCRS_COMMIT",
  "gccrs_ref": "${GCCRS_REF:-main}",
  "core_errors_file": "$CORE_LOG",
  "kernel_errors_file": "$KERNEL_LOG"
}
EOF

# ── Commit and push ──────────────────────────────────────────────────────────
git -C "$TEMP_DIR" config user.name  "github-actions[bot]"
git -C "$TEMP_DIR" config user.email "github-actions[bot]@users.noreply.github.com"

git -C "$TEMP_DIR" add "$DATE/"

if git -C "$TEMP_DIR" diff --cached --quiet; then
    echo "No changes to commit."
    exit 0
fi

git -C "$TEMP_DIR" commit -m "Weekly error log: $DATE

gccrs commit: $GCCRS_COMMIT"

echo "Pushing to error-logs branch..."
git -C "$TEMP_DIR" push origin error-logs

echo "=== Logs stored successfully ==="
