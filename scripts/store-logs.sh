#!/bin/bash
# store-logs.sh — Commit this week's error logs to the error-logs branch.
#
# Uses git-worktree to avoid a second clone.  The worktree shares the
# existing repository's credentials, so this works both in GitHub Actions
# (GITHUB_TOKEN) and locally (SSH / credential helper).
#
# On the first run the error-logs branch is created as an orphan so its
# history is independent of the main branch.
set -euo pipefail

DATE=$(date +%Y-%m-%d)
WORKTREE_DIR="../error-logs-worktree"

# Files to archive
CORE_LOG="${1:-core_errors.txt}"
KERNEL_LOG="${2:-kernel_errors.txt}"
REPORT="${3:-report.md}"

echo "=== Storing logs for $DATE to error-logs branch ==="

# ── Fetch the error-logs branch (ignore failure if it doesn't exist) ─────
git fetch origin error-logs:refs/remotes/origin/error-logs 2>/dev/null || true

# ── Create (or recreate) the worktree ────────────────────────────────────
# Clean up any stale worktree from a previous run
if git worktree list | grep -q "$WORKTREE_DIR"; then
    echo "Removing stale worktree at $WORKTREE_DIR ..."
    git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
fi

if git rev-parse --verify origin/error-logs >/dev/null 2>&1; then
    echo "error-logs branch exists on origin; checking it out ..."
    git worktree add "$WORKTREE_DIR" origin/error-logs
else
    echo "First run: creating orphan error-logs branch ..."
    # Create a detached worktree then make it an orphan branch
    git worktree add --detach "$WORKTREE_DIR"
    git -C "$WORKTREE_DIR" checkout --orphan error-logs
    # Clear the index — orphan branches start empty
    git -C "$WORKTREE_DIR" rm -rf --quiet . 2>/dev/null || true
fi

# ── Copy files into dated directory ──────────────────────────────────────
mkdir -p "$WORKTREE_DIR/$DATE"

for f in "$CORE_LOG" "$KERNEL_LOG" "$REPORT"; do
    if [ -f "$f" ]; then
        cp "$f" "$WORKTREE_DIR/$DATE/"
        echo "  Copied: $f"
    else
        echo "  Warning: $f not found, skipping"
    fi
done

# Write a metadata file
GCCRS_COMMIT="${GCCRS_COMMIT:-unknown}"
cat > "$WORKTREE_DIR/$DATE/metadata.json" << EOF
{
  "date": "$DATE",
  "gccrs_commit": "$GCCRS_COMMIT",
  "gccrs_ref": "${GCCRS_REF:-main}",
  "core_errors_file": "$CORE_LOG",
  "kernel_errors_file": "$KERNEL_LOG"
}
EOF

# ── Commit ───────────────────────────────────────────────────────────────
git -C "$WORKTREE_DIR" config user.name  "github-actions[bot]"
git -C "$WORKTREE_DIR" config user.email "github-actions[bot]@users.noreply.github.com"

git -C "$WORKTREE_DIR" add "$DATE/"

if git -C "$WORKTREE_DIR" diff --cached --quiet; then
    echo "No changes to commit."
    git worktree remove "$WORKTREE_DIR"
    exit 0
fi

git -C "$WORKTREE_DIR" commit -m "Weekly error log: $DATE

gccrs commit: $GCCRS_COMMIT"

# ── Push ─────────────────────────────────────────────────────────────────
echo "Pushing to error-logs branch ..."
git -C "$WORKTREE_DIR" push origin HEAD:error-logs

# ── Cleanup ──────────────────────────────────────────────────────────────
git worktree remove "$WORKTREE_DIR"

echo "=== Logs stored successfully ==="
