#!/bin/bash
# compile-with-gccrs.sh — Compile a Rust file with gccrs and capture errors.
#
# Usage: compile-with-gccrs.sh <gccrs_binary> <rust_file> <output_log> [edition]
#
# Errors are expected for the target files being tracked, so this script
# always exits 0.  The error log is normalized for consistent diffing:
#   - Absolute paths replaced with relative (repo-root or gccrs-src-root)
#   - Trailing whitespace trimmed
#
# If the compiler binary exits with a signal or the file doesn't exist,
# those conditions are recorded in the output log (the script still exits 0).
set -euo pipefail

GCCRS_BIN="$1"
RUST_FILE="$2"
OUTPUT_LOG="$3"
EDITION="${4:-}"  # optional, e.g. 2015, 2018, 2021

if [ ! -x "$GCCRS_BIN" ]; then
    {
        echo "=== FATAL: gccrs binary not found at $GCCRS_BIN ==="
    } > "$OUTPUT_LOG"
    exit 0
fi

if [ ! -f "$RUST_FILE" ]; then
    {
        echo "=== FATAL: Rust source file not found: $RUST_FILE ==="
    } > "$OUTPUT_LOG"
    exit 0
fi

echo "=== Compiling $RUST_FILE with gccrs ==="

# Resolve to absolute paths for the normalizer
GCCRS_BIN_ABS=$(realpath "$GCCRS_BIN")
RUST_FILE_ABS=$(realpath "$RUST_FILE")
RUST_FILE_DIR=$(dirname "$RUST_FILE_ABS")

# Detect root directories for path normalization
# We'll strip the gccrs-src prefix and the repo-root prefix.
GCCRS_SRC_ROOT=""
REPO_ROOT=""
if [ -n "${GCCRS_SRC:-}" ] && [ -d "${GCCRS_SRC}" ]; then
    GCCRS_SRC_ROOT=$(realpath "${GCCRS_SRC}")
fi
if [ -n "${GITHUB_WORKSPACE:-}" ]; then
    REPO_ROOT="$GITHUB_WORKSPACE"
else
    # Try to detect repo root (parent of the directory containing .git)
    REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
fi

# Generate a wrapper script that sets up the gccrs library path
# gccrs needs to find its libraries (libgcc_s, libstdc++, etc.)
BUILD_DIR=$(dirname "$(dirname "$GCCRS_BIN_ABS")")

TEMP_OUT=$(mktemp)
TEMP_ERR=$(mktemp)
trap 'rm -f "$TEMP_OUT" "$TEMP_ERR"' EXIT

# Run gccrs with a timeout of 5 minutes per file
# -B tells the driver where to find sub-programs (crab1, cc1, as, ld, etc.)
# This is needed because we run from the build tree, not an installed prefix.
GCCRS_LIBEXEC=$(dirname "$GCCRS_BIN_ABS")
EDITION_FLAG=()
if [ -n "$EDITION" ]; then
    EDITION_FLAG=("-frust-edition=${EDITION}")
fi

timeout 300s "$GCCRS_BIN_ABS" \
    -B "$GCCRS_LIBEXEC" \
    -c "$RUST_FILE_ABS" \
    -o /dev/null \
    -frust-c-style-string-literals \
    "${EDITION_FLAG[@]}" \
    >"$TEMP_OUT" 2>"$TEMP_ERR" || true

# Normalize paths in the error output
normalize_paths() {
    local input="$1"
    local WORKSPACE="${REPO_ROOT:-}"
    local GRSRC="${GCCRS_SRC_ROOT:-}"

    # Replace absolute paths with relative ones for consistent diffing
    if [ -n "$WORKSPACE" ]; then
        sed -i "s|${WORKSPACE}/|./|g" "$input" 2>/dev/null || true
    fi
    if [ -n "$GRSRC" ] && [ "$GRSRC" != "$WORKSPACE" ]; then
        sed -i "s|${GRSRC}/|gccrs-src/|g" "$input" 2>/dev/null || true
    fi

    # Remove trailing whitespace
    sed -i 's/[[:space:]]*$//' "$input" 2>/dev/null || true
}

# Combine stdout and stderr, normalize, and save
cat "$TEMP_ERR" "$TEMP_OUT" > "$OUTPUT_LOG"
normalize_paths "$OUTPUT_LOG"

# Add a header with metadata
ERROR_COUNT=$(grep -c "error:" "$OUTPUT_LOG" 2>/dev/null || echo 0)
WARNING_COUNT=$(grep -c "warning:" "$OUTPUT_LOG" 2>/dev/null || echo 0)
{
    echo ""
    echo "=== Summary ==="
    echo "File: $RUST_FILE"
    echo "Errors: $ERROR_COUNT"
    echo "Warnings: $WARNING_COUNT"
    echo "gccrs binary: $GCCRS_BIN"
} >> "$OUTPUT_LOG"

echo "=== Done: $ERROR_COUNT errors, $WARNING_COUNT warnings → $OUTPUT_LOG ==="
