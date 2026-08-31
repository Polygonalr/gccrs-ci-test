# gccrs Error Tracking Report

**Date:** 2026-08-31
**gccrs commit:** [`bb00634ab`](https://github.com/Rust-GCC/gccrs/commit/bb00634ab) (branch: `master`)

## 📦 gccrs `core/src/lib.rs`

**Total errors:** 1

| Category | Count |
|----------|-------|
| Fixed ✅ | 11 |
| New ❌ | 1 |
| Shifted 🔄 | 0 |
| Persistent | 0 |
| **Previous total** | 11 |

### ✅ Fixed Errors (were present last week, now gone)

- `./gccrs-src/libgrust/rustc-lib/core/src/cmp.rs:590:36` — **error**: failed to resolve type path segment: ‘Ordering’
- `./gccrs-src/libgrust/rustc-lib/core/src/cmp.rs:590:5` — **error**: failed to resolve return type
- `./gccrs-src/libgrust/rustc-lib/core/src/cmp.rs:1020:39` — **error**: failed to resolve type path segment: ‘Ordering’
- `./gccrs-src/libgrust/rustc-lib/core/src/cmp.rs:1021:11` — **error**: expected function, found ‘F’ [E0618]
- `./gccrs-src/libgrust/rustc-lib/core/src/cmp.rs:1022:9` — **error**: cannot find value ‘Ordering::Less’ in this scope [E0425]
- `./gccrs-src/libgrust/rustc-lib/core/src/cmp.rs:1022:26` — **error**: cannot find value ‘Ordering::Equal’ in this scope [E0425]
- `./gccrs-src/libgrust/rustc-lib/core/src/cmp.rs:1022:9` — **error**: mismatched types, expected ‘T?’ but got ‘<tyty::error>’ [E0308]
- `./gccrs-src/libgrust/rustc-lib/core/src/cmp.rs:1022:9` — **error**: mismatched types, expected ‘<tyty::error>’ but got ‘<tyty::error>’ [E0308]
- `./gccrs-src/libgrust/rustc-lib/core/src/cmp.rs:1023:9` — **error**: cannot find value ‘Ordering::Greater’ in this scope [E0425]
- `./gccrs-src/libgrust/rustc-lib/core/src/fmt/mod.rs:977:45` — **error**: failed to resolve type path segment: ‘Result’
- `./gccrs-src/libgrust/rustc-lib/core/src/fmt/mod.rs:977:5` — **error**: failed to resolve return type

### ❌ New Errors (not present last week)

- `./gccrs-src/libgrust/rustc-lib/core/src/task/wake.rs:67:36` — **error**: failed to resolve type path segment: ‘RawWaker’

## 🐧 `linux-rust/kernel/lib.rs`

**Total errors:** 3752

| Category | Count |
|----------|-------|
| Fixed ✅ | 0 |
| New ❌ | 0 |
| Shifted 🔄 | 0 |
| Persistent | 3752 |
| **Previous total** | 3752 |

## 📊 Overall Summary

| Metric | Count |
|--------|-------|
| Total errors fixed | 11 |
| Total new errors | 1 |
| Total shifted errors | 0 |
| Net change | -10 |

🎉 **10 more errors fixed than introduced this week!**

---
*Report generated on 2026-08-31*
