# gccrs Error Tracking Report

**Date:** 2026-08-24
**gccrs commit:** [`00a99e715`](https://github.com/Rust-GCC/gccrs/commit/00a99e715) (branch: `master`)

## 📦 gccrs `core/src/lib.rs`

**Total errors:** 11

| Category | Count |
|----------|-------|
| Fixed ✅ | 25 |
| New ❌ | 11 |
| Shifted 🔄 | 0 |
| Persistent | 0 |
| **Previous total** | 25 |

### ✅ Fixed Errors (were present last week, now gone)

- `./gccrs-src/libgrust/rustc-lib/core/src/ptr/mod.rs:1142:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/panic.rs:30:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/panic.rs:175:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/panicking.rs:38:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/panicking.rs:63:3` — **error**: unknown lang item
- `./gccrs-src/libgrust/rustc-lib/core/src/pin.rs:560:7` — **error**: unknown lang item
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

### ❌ New Errors (not present last week)

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
| Total errors fixed | 25 |
| Total new errors | 11 |
| Total shifted errors | 0 |
| Net change | -14 |

🎉 **14 more errors fixed than introduced this week!**

---
*Report generated on 2026-08-24*
