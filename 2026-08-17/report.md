# gccrs Error Tracking Report

**Date:** 2026-08-17
**gccrs commit:** [`9482951a8`](https://github.com/Rust-GCC/gccrs/commit/9482951a8) (branch: `master`)

## 📦 gccrs `core/src/lib.rs`

**Total errors:** 25

| Category | Count |
|----------|-------|
| Fixed ✅ | 3 |
| New ❌ | 19 |
| Shifted 🔄 | 0 |
| Persistent | 6 |
| **Previous total** | 9 |

### ✅ Fixed Errors (were present last week, now gone)

- `./gccrs-src/libgrust/rustc-lib/core/src/marker.rs:124:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/ops/unsize.rs:35:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/ops/unsize.rs:85:3` — **error**: unknown lang item

### ❌ New Errors (not present last week)

- `./gccrs-src/libgrust/rustc-lib/core/src/future/mod.rs:56:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/future/mod.rs:90:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/simd_llvm.rs:3:1` — **error**: invalid ABI: found ‘platform-intrinsic’ [E0703]
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86/eflags.rs:33:5` — **error**: unsupported ‘llvm_asm’ construct
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86/eflags.rs:64:5` — **error**: unsupported ‘llvm_asm’ construct
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86/xsave.rs:90:5` — **error**: unsupported ‘llvm_asm’ construct
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86/rdrand.rs:7:1` — **error**: invalid ABI: found ‘unadjusted’ [E0703]
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86/adx.rs:5:1` — **error**: invalid ABI: found ‘unadjusted’ [E0703]
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86/bt.rs:10:5` — **error**: unsupported ‘llvm_asm’ construct
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86/bt.rs:23:5` — **error**: unsupported ‘llvm_asm’ construct
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86/bt.rs:36:5` — **error**: unsupported ‘llvm_asm’ construct
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86/bt.rs:49:5` — **error**: unsupported ‘llvm_asm’ construct
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86/f16c.rs:15:1` — **error**: invalid ABI: found ‘unadjusted’ [E0703]
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86_64/rdrand.rs:8:1` — **error**: invalid ABI: found ‘unadjusted’ [E0703]
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86_64/adx.rs:5:1` — **error**: invalid ABI: found ‘unadjusted’ [E0703]
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86_64/bt.rs:10:5` — **error**: unsupported ‘llvm_asm’ construct
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86_64/bt.rs:23:5` — **error**: unsupported ‘llvm_asm’ construct
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86_64/bt.rs:36:5` — **error**: unsupported ‘llvm_asm’ construct
- `./gccrs-src/libgrust/rustc-lib/core/src/../../stdarch/crates/core_arch/src/x86_64/bt.rs:49:5` — **error**: unsupported ‘llvm_asm’ construct

## 🐧 `linux-rust/kernel/lib.rs`

**Total errors:** 3752

| Category | Count |
|----------|-------|
| Fixed ✅ | 3 |
| New ❌ | 0 |
| Shifted 🔄 | 0 |
| Persistent | 3752 |
| **Previous total** | 3755 |

### ✅ Fixed Errors

- `./linux-rust/kernel/lib.rs:235:17` — **error**: could not resolve type path ‘core::panic::PanicInfo’ [E0412]
- `./linux-rust/kernel/lib.rs:352:40` — **error**: could not resolve type path ‘core::panic::Location’ [E0412]
- `./linux-rust/kernel/lib.rs:352:74` — **error**: could not resolve type path ‘core::ffi::CStr’ [E0412]

## 📊 Overall Summary

| Metric | Count |
|--------|-------|
| Total errors fixed | 6 |
| Total new errors | 19 |
| Total shifted errors | 0 |
| Net change | +13 |

⚠️ **13 more errors introduced than fixed this week.**

---
*Report generated on 2026-08-17*
