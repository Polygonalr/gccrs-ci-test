# gccrs Error Tracking Report

**Date:** 2026-08-10
**gccrs commit:** [`db418335d`](https://github.com/Rust-GCC/gccrs/commit/db418335d) (branch: `master`)

## 📦 gccrs `core/src/lib.rs`

**Total errors:** 9

| Category | Count |
|----------|-------|
| Fixed ✅ | 3 |
| New ❌ | 9 |
| Shifted 🔄 | 0 |
| Persistent | 0 |
| **Previous total** | 3 |

### ✅ Fixed Errors (were present last week, now gone)

- `./gccrs-src/libgrust/rustc-lib/core/src/num/dec2flt/table.rs:7:3` — **error**: unknown attribute
- `./gccrs-src/libgrust/rustc-lib/core/src/num/dec2flt/table.rs:1237:3` — **error**: unknown attribute
- `./gccrs-src/libgrust/rustc-lib/core/src/num/dec2flt/table.rs:1252:3` — **error**: unknown attribute

### ❌ New Errors (not present last week)

- `./gccrs-src/libgrust/rustc-lib/core/src/ptr/mod.rs:1142:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/marker.rs:124:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/ops/unsize.rs:35:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/ops/unsize.rs:85:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/panic.rs:30:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/panic.rs:175:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/panicking.rs:38:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/panicking.rs:63:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/pin.rs:560:7` — **error**: unknown lang item

## 🐧 `linux-rust/kernel/lib.rs`

**Total errors:** 3755

| Category | Count |
|----------|-------|
| Fixed ✅ | 28 |
| New ❌ | 0 |
| Shifted 🔄 | 0 |
| Persistent | 3755 |
| **Previous total** | 3783 |

### ✅ Fixed Errors

- `./linux-rust/kernel/bitmap.rs:86:7` — **error**: unknown attribute ‘expect’
- `./linux-rust/kernel/debugfs.rs:379:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/debugfs.rs:400:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/driver.rs:170:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/irq/request.rs:60:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/irq/request.rs:184:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/irq/request.rs:300:7` — **error**: unknown attribute ‘expect’
- `./linux-rust/kernel/irq/request.rs:405:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/list/arc_field.rs:59:7` — **error**: unknown attribute ‘expect’
- `./linux-rust/kernel/maple_tree.rs:27:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/maple_tree.rs:38:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/miscdevice.rs:56:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/miscdevice.rs:114:3` — **error**: unknown attribute ‘vtable’
- `./linux-rust/kernel/print.rs:17:3` — **error**: unknown attribute ‘expect’
- `./linux-rust/kernel/print.rs:18:3` — **error**: unknown attribute ‘export’
- `./linux-rust/kernel/revocable.rs:66:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/sync/arc.rs:145:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/sync/completion.rs:66:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/sync/condvar.rs:81:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/sync/lock.rs:105:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/sync/poll.rs:68:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/sync.rs:37:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/time/hrtimer.rs:85:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/workqueue.rs:352:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/workqueue.rs:477:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/workqueue.rs:645:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/xarray.rs:55:3` — **error**: unknown attribute ‘pin_data’
- `./linux-rust/kernel/lib.rs:234:3` — **error**: unknown attribute ‘panic_handler’

## 📊 Overall Summary

| Metric | Count |
|--------|-------|
| Total errors fixed | 31 |
| Total new errors | 9 |
| Total shifted errors | 0 |
| Net change | -22 |

🎉 **22 more errors fixed than introduced this week!**

---
*Report generated on 2026-08-10*
