# gccrs Error Tracking Report

**Date:** 2026-07-20
**gccrs commit:** [`f53262ab4`](https://github.com/Rust-GCC/gccrs/commit/f53262ab4) (branch: `master`)

## 📦 gccrs `core/src/lib.rs`

**Total errors:** 16980

| Category | Count |
|----------|-------|
| Fixed ✅ | 6 |
| New ❌ | 0 |
| Shifted 🔄 | 0 |
| Persistent | 16980 |
| **Previous total** | 16986 |

### ✅ Fixed Errors (were present last week, now gone)

- `./gccrs-src/libgrust/rustc-lib/core/src/iter/adapters/chain.rs:36:12` — **error**: could not resolve path ‘super::super’ [E0433]
- `./gccrs-src/libgrust/rustc-lib/core/src/iter/adapters/flatten.rs:18:12` — **error**: could not resolve path ‘super::super’ [E0433]
- `./gccrs-src/libgrust/rustc-lib/core/src/iter/adapters/flatten.rs:133:12` — **error**: could not resolve path ‘super::super’ [E0433]
- `./gccrs-src/libgrust/rustc-lib/core/src/iter/adapters/zip.rs:24:12` — **error**: could not resolve path ‘super::super’ [E0433]
- `./gccrs-src/libgrust/rustc-lib/core/src/fmt/mod.rs:238:16` — **error**: could not resolve type path ‘Opaque’ [E0412]
- `./gccrs-src/libgrust/rustc-lib/core/src/fmt/mod.rs:239:20` — **error**: could not resolve type path ‘Opaque’ [E0412]

## 🐧 `linux-rust/kernel/lib.rs`

**Total errors:** 3786

| Category | Count |
|----------|-------|
| Fixed ✅ | 1 |
| New ❌ | 0 |
| Shifted 🔄 | 0 |
| Persistent | 3786 |
| **Previous total** | 3787 |

### ✅ Fixed Errors

- `./linux-rust/kernel/sync/atomic/predefine.rs:117:16` — **error**: unresolved import ‘super::super’ [E0433]

## 📊 Overall Summary

| Metric | Count |
|--------|-------|
| Total errors fixed | 7 |
| Total new errors | 0 |
| Total shifted errors | 0 |
| Net change | -7 |

🎉 **7 more errors fixed than introduced this week!**

---
*Report generated on 2026-07-20*
