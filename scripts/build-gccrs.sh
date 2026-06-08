#!/bin/bash
# build-gccrs.sh — Clone and build gccrs from source.
#
# Environment variables used:
#   GCCRS_REF     — branch/tag/commit to check out (default: master)
#   GCCRS_SRC     — path for the gccrs source checkout (default: gccrs-src)
#   GCCRS_BUILD   — path for the out-of-tree build directory (default: gccrs-build)
#   CCACHE_DIR    — ccache directory (default: ~/.cache/ccache)
#   NPROC         — number of parallel jobs (default: nproc)
set -euo pipefail

GCCRS_REF="${GCCRS_REF:-master}"
GCCRS_SRC="${GCCRS_SRC:-gccrs-src}"
GCCRS_BUILD="${GCCRS_BUILD:-gccrs-build}"
NPROC="${NPROC:-$(nproc)}"

# ── Clone ────────────────────────────────────────────────────────────────────
if [ -d "$GCCRS_SRC/.git" ]; then
    echo "=== gccrs source already cloned, fetching latest ==="
    git -C "$GCCRS_SRC" fetch origin --depth=1 "$GCCRS_REF"
    git -C "$GCCRS_SRC" checkout FETCH_HEAD
else
    echo "=== Cloning gccrs (ref: $GCCRS_REF) ==="
    git clone --depth=1 --branch "$GCCRS_REF" \
        https://github.com/Rust-GCC/gccrs.git "$GCCRS_SRC"
fi

GCCRS_COMMIT=$(git -C "$GCCRS_SRC" rev-parse --short HEAD)
echo "=== gccrs commit: $GCCRS_COMMIT ==="

# ── Configure ccache ─────────────────────────────────────────────────────────
export CCACHE_DIR="${CCACHE_DIR:-$HOME/.cache/ccache}"
export CCACHE_MAXSIZE="${CCACHE_MAXSIZE:-2G}"
mkdir -p "$CCACHE_DIR"
ccache -z > /dev/null 2>&1 || true
export CC="ccache gcc"
export CXX="ccache g++"

# ── Configure ────────────────────────────────────────────────────────────────
if [ -f "$GCCRS_BUILD/Makefile" ]; then
    echo "=== Build directory already configured, skipping configure ==="
else
    echo "=== Configuring gccrs ==="
    mkdir -p "$GCCRS_BUILD"
    ( cd "$GCCRS_BUILD" && \
        "$OLDPWD/$GCCRS_SRC/configure" \
            --enable-languages=rust \
            --disable-bootstrap \
            --disable-multilib \
            --disable-libsanitizer \
            --quiet )
fi

# ── Build ────────────────────────────────────────────────────────────────────
echo "=== Building gccrs ($NPROC parallel jobs) ==="
make -C "$GCCRS_BUILD" -j"$NPROC" 2>&1 | tail -20

# Verify the compiler exists
GCCRS_BIN="$GCCRS_BUILD/gcc/gccrs"
if [ ! -x "$GCCRS_BIN" ]; then
    echo "ERROR: gccrs binary not found at $GCCRS_BIN"
    echo "Contents of $GCCRS_BUILD/gcc/:"
    ls -la "$GCCRS_BUILD/gcc/" || true
    exit 1
fi

echo "=== gccrs built successfully: $GCCRS_BIN ==="
"$GCCRS_BIN" --version 2>&1 || true

# Print ccache stats
ccache -s || true
