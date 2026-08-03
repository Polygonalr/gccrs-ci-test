# gccrs Error Tracking Report

**Date:** 2026-08-03
**gccrs commit:** [`481e776ea`](https://github.com/Rust-GCC/gccrs/commit/481e776ea) (branch: `master`)

## 📦 gccrs `core/src/lib.rs`

**Total errors:** 3

| Category | Count |
|----------|-------|
| Fixed ✅ | 0 |
| New ❌ | 3 |
| Shifted 🔄 | 0 |
| Persistent | 0 |
| **Previous total** | 0 |

### ❌ New Errors (not present last week)

- `./gccrs-src/libgrust/rustc-lib/core/src/num/dec2flt/table.rs:7:3` — **error**: unknown attribute
- `./gccrs-src/libgrust/rustc-lib/core/src/num/dec2flt/table.rs:1237:3` — **error**: unknown attribute
- `./gccrs-src/libgrust/rustc-lib/core/src/num/dec2flt/table.rs:1252:3` — **error**: unknown attribute

## 🐧 `linux-rust/kernel/lib.rs`

**Total errors:** 3783

| Category | Count |
|----------|-------|
| Fixed ✅ | 3 |
| New ❌ | 0 |
| Shifted 🔄 | 0 |
| Persistent | 3783 |
| **Previous total** | 3786 |

### ✅ Fixed Errors

- `./linux-rust/kernel/str.rs:406:53` — **error**: could not resolve type path ‘Error’ [E0412]
- `./linux-rust/kernel/str.rs:408:57` — **error**: could not resolve type path ‘Error’ [E0412]
- `./linux-rust/kernel/str.rs:816:67` — **error**: could not resolve type path ‘Error’ [E0412]

## 📊 Overall Summary

| Metric | Count |
|--------|-------|
| Total errors fixed | 3 |
| Total new errors | 3 |
| Total shifted errors | 0 |
| Net change | +0 |

➖ **No net change in total errors.**

---
*Report generated on 2026-08-03*
