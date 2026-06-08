#!/usr/bin/env python3
"""
compare-errors.py — Compare two weeks of gccrs error logs and generate a report.

Parses gccrs diagnostic output, compares against the previous week's logs,
and produces a Markdown summary of fixed, new, and persistent errors.

Usage:
    python3 compare-errors.py \\
        --core-log core_errors.txt \\
        --kernel-log kernel_errors.txt \\
        --gccrs-commit abc1234 \\
        --gccrs-ref main \\
        --output report.md
"""

import argparse
import os
import re
import subprocess
import sys
from datetime import date
from typing import Dict, List, Optional, Set, Tuple

# ── Error key extraction ─────────────────────────────────────────────────────

# gccrs produces GCC-style diagnostics:
#   filename:line:col: error: message
#   filename:line:col: warning: message
#   filename:line:col: note: message
#
# Multi-line errors have continuation lines indented or starting with " |".
# We group contiguous lines into blocks and use the first error/warning line
# as the block key.

DIAG_LINE_RE = re.compile(
    r"^(.+?):(\d+):(\d+):\s*(error|fatal error|warning|note):\s*(.*)"
)

CONTINUATION_RE = re.compile(r"^\s+[|│]")


def parse_error_log(filepath: str) -> List[dict]:
    """Parse a gccrs error log into a list of structured error blocks.

    Each returned dict has:
        file, line, col, kind, message, raw_block
    """
    if not os.path.exists(filepath):
        return []

    blocks: List[dict] = []
    current_block: Optional[dict] = None
    raw_lines: List[str] = []

    with open(filepath, "r", encoding="utf-8", errors="replace") as fh:
        for line in fh:
            line = line.rstrip("\n\r")

            m = DIAG_LINE_RE.match(line)
            if m:
                # Flush previous block
                if current_block is not None:
                    current_block["raw_block"] = "\n".join(raw_lines)
                    blocks.append(current_block)

                current_block = {
                    "file": m.group(1),
                    "line": int(m.group(2)),
                    "col": int(m.group(3)),
                    "kind": m.group(4).strip(),
                    "message": m.group(5).strip(),
                }
                raw_lines = [line]
            elif current_block is not None:
                # Check if this is a continuation (source snippet)
                if CONTINUATION_RE.match(line) or line.strip().startswith("|"):
                    raw_lines.append(line)
                elif line.strip() == "":
                    raw_lines.append(line)
                else:
                    # Non-continuation, non-diagnostic line → flush block
                    current_block["raw_block"] = "\n".join(raw_lines)
                    blocks.append(current_block)
                    current_block = None
                    raw_lines = []

    # Flush final block
    if current_block is not None:
        current_block["raw_block"] = "\n".join(raw_lines)
        blocks.append(current_block)

    return blocks


def error_key(block: dict) -> str:
    """Produce a stable key for an error block for comparison."""
    return f"{block['file']}:{block['line']}:{block['col']}: {block['kind']}: {block['message']}"


def error_key_no_line(block: dict) -> str:
    """Produce a key without line/col info (coarser comparison)."""
    return f"{block['file']}: {block['kind']}: {block['message']}"


# ── Comparison ───────────────────────────────────────────────────────────────


def compare_errors(
    current: List[dict],
    previous: List[dict],
) -> Tuple[List[dict], List[dict], List[dict], List[Tuple[dict, List[dict]]]]:
    """Compare two error lists.

    Returns (fixed, new, persistent, shifted):
        fixed:  present in previous but not in current
        new:    present in current but not in previous
        persistent: present in both
        shifted: errors with same message but different line numbers
    """
    prev_keys = {error_key(b): b for b in previous}
    curr_keys = {error_key(b): b for b in current}

    fixed = [
        previous[i] for i, b in enumerate(previous) if error_key(b) not in curr_keys
    ]
    new = [current[i] for i, b in enumerate(current) if error_key(b) not in prev_keys]
    persistent = [
        current[i] for i, b in enumerate(current) if error_key(b) in prev_keys
    ]

    # Also do a line-insensitive pass for attribution hints
    prev_keys_no_line = {}
    for b in previous:
        key = error_key_no_line(b)
        prev_keys_no_line.setdefault(key, []).append(b)

    curr_keys_no_line = {}
    for b in current:
        key = error_key_no_line(b)
        curr_keys_no_line.setdefault(key, []).append(b)

    # Detect "shifted" errors (same message, different line) for a note
    shifted = []
    for b in new[:]:
        key = error_key_no_line(b)
        if key in prev_keys_no_line:
            shifted.append((b, prev_keys_no_line[key]))
            new.remove(b)  # Reclassify as shifted rather than truly new

    return fixed, new, persistent, shifted


# ── Previous logs retrieval ──────────────────────────────────────────────────


def get_previous_dates() -> List[str]:
    """List dated directories from the error-logs remote branch."""
    try:
        result = subprocess.run(
            ["git", "ls-tree", "--name-only", "origin/error-logs"],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            return []
        dirs = [line.strip() for line in result.stdout.splitlines()]
        # Filter to YYYY-MM-DD pattern
        date_dirs = [d for d in dirs if re.match(r"^\d{4}-\d{2}-\d{2}$", d)]
        date_dirs.sort(reverse=True)
        return date_dirs
    except Exception:
        return []


def read_previous_log(date_dir: str, name: str) -> Optional[str]:
    """Read a previous error log from the error-logs branch via git show."""
    try:
        result = subprocess.run(
            ["git", "show", f"origin/error-logs:{date_dir}/{name}"],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            return None
        return result.stdout
    except Exception:
        return None


def extract_errors_from_text(text: str) -> List[dict]:
    """Parse error blocks from raw text (used for previous logs)."""
    lines = text.splitlines()

    blocks: List[dict] = []
    current_block: Optional[dict] = None
    raw_lines: List[str] = []

    for line in lines:
        line = line.rstrip("\n\r")
        m = DIAG_LINE_RE.match(line)
        if m:
            if current_block is not None:
                current_block["raw_block"] = "\n".join(raw_lines)
                blocks.append(current_block)
            current_block = {
                "file": m.group(1),
                "line": int(m.group(2)),
                "col": int(m.group(3)),
                "kind": m.group(4).strip(),
                "message": m.group(5).strip(),
            }
            raw_lines = [line]
        elif current_block is not None:
            if CONTINUATION_RE.match(line) or line.strip().startswith("|"):
                raw_lines.append(line)
            elif line.strip() == "":
                raw_lines.append(line)
            else:
                current_block["raw_block"] = "\n".join(raw_lines)
                blocks.append(current_block)
                current_block = None
                raw_lines = []

    if current_block is not None:
        current_block["raw_block"] = "\n".join(raw_lines)
        blocks.append(current_block)

    return blocks


# ── Report generation ────────────────────────────────────────────────────────


def generate_report(
    core_errors: List[dict],
    kernel_errors: List[dict],
    prev_core_errors: List[dict],
    prev_kernel_errors: List[dict],
    prev_date: Optional[str],
    gccrs_commit: str,
    gccrs_ref: str,
    is_first_run: bool,
) -> str:
    today = date.today().isoformat()

    lines: List[str] = []
    lines.append(f"# gccrs Error Tracking Report")
    lines.append(f"")
    lines.append(f"**Date:** {today}")
    lines.append(
        f"**gccrs commit:** [`{gccrs_commit}`](https://github.com/Rust-GCC/gccrs/commit/{gccrs_commit}) "
        f"(branch: `{gccrs_ref}`)"
    )
    lines.append(f"")

    if is_first_run:
        lines.append("## ⚠️ First Run — Baseline Established")
        lines.append("")
        lines.append("This is the first run. No previous data to compare against.")
        lines.append("Subsequent runs will compare against this baseline.")
        lines.append("")

    # ── Core lib.rs ───────────────────────────────────────────────────────
    lines.append("## 📦 gccrs `core/src/lib.rs`")
    lines.append("")
    lines.append(f"**Total errors:** {len(core_errors)}")
    lines.append("")

    if not is_first_run:
        core_fixed, core_new, core_persist, core_shifted = compare_errors(
            core_errors, prev_core_errors
        )
        lines.append(f"| Category | Count |")
        lines.append(f"|----------|-------|")
        lines.append(f"| Fixed ✅ | {len(core_fixed)} |")
        lines.append(f"| New ❌ | {len(core_new)} |")
        lines.append(f"| Shifted 🔄 | {len(core_shifted)} |")
        lines.append(f"| Persistent | {len(core_persist)} |")
        lines.append(f"| **Previous total** | {len(prev_core_errors)} |")
        lines.append("")

        if core_fixed:
            lines.append("### ✅ Fixed Errors (were present last week, now gone)")
            lines.append("")
            for b in core_fixed:
                lines.append(
                    f"- `{b['file']}:{b['line']}:{b['col']}` — **{b['kind']}**: {b['message']}"
                )
            lines.append("")

        if core_new:
            lines.append("### ❌ New Errors (not present last week)")
            lines.append("")
            for b in core_new:
                lines.append(
                    f"- `{b['file']}:{b['line']}:{b['col']}` — **{b['kind']}**: {b['message']}"
                )
            lines.append("")

        if core_shifted:
            lines.append(
                "### 🔄 Shifted Errors (same message, different line — likely due to source changes)"
            )
            lines.append("")
            for b, old_list in core_shifted:
                old_lines = ", ".join(f"{o['file']}:{o['line']}" for o in old_list)
                lines.append(
                    f"- `{b['file']}:{b['line']}:{b['col']}` — was at {old_lines}: **{b['kind']}**: {b['message']}"
                )
            lines.append("")

    # ── Kernel lib.rs ─────────────────────────────────────────────────────
    lines.append("## 🐧 `linux-rust/kernel/lib.rs`")
    lines.append("")
    lines.append(f"**Total errors:** {len(kernel_errors)}")
    lines.append("")

    if not is_first_run:
        kern_fixed, kern_new, kern_persist, kern_shifted = compare_errors(
            kernel_errors, prev_kernel_errors
        )
        lines.append(f"| Category | Count |")
        lines.append(f"|----------|-------|")
        lines.append(f"| Fixed ✅ | {len(kern_fixed)} |")
        lines.append(f"| New ❌ | {len(kern_new)} |")
        lines.append(f"| Shifted 🔄 | {len(kern_shifted)} |")
        lines.append(f"| Persistent | {len(kern_persist)} |")
        lines.append(f"| **Previous total** | {len(prev_kernel_errors)} |")
        lines.append("")

        if kern_fixed:
            lines.append("### ✅ Fixed Errors")
            lines.append("")
            for b in kern_fixed:
                lines.append(
                    f"- `{b['file']}:{b['line']}:{b['col']}` — **{b['kind']}**: {b['message']}"
                )
            lines.append("")

        if kern_new:
            lines.append("### ❌ New Errors")
            lines.append("")
            for b in kern_new:
                lines.append(
                    f"- `{b['file']}:{b['line']}:{b['col']}` — **{b['kind']}**: {b['message']}"
                )
            lines.append("")

        if kern_shifted:
            lines.append("### 🔄 Shifted Errors")
            lines.append("")
            for b, old_list in kern_shifted:
                old_lines = ", ".join(f"{o['file']}:{o['line']}" for o in old_list)
                lines.append(
                    f"- `{b['file']}:{b['line']}:{b['col']}` — was at {old_lines}: **{b['kind']}**: {b['message']}"
                )
            lines.append("")

    # ── Summary ───────────────────────────────────────────────────────────
    if not is_first_run:
        total_fixed = len(core_fixed) + len(kern_fixed)
        total_new = len(core_new) + len(kern_new)
        total_shifted = len(core_shifted) + len(kern_shifted)
        lines.append("## 📊 Overall Summary")
        lines.append("")
        lines.append(f"| Metric | Count |")
        lines.append(f"|--------|-------|")
        lines.append(f"| Total errors fixed | {total_fixed} |")
        lines.append(f"| Total new errors | {total_new} |")
        lines.append(f"| Total shifted errors | {total_shifted} |")
        lines.append(f"| Net change | {total_new - total_fixed:+d} |")
        lines.append("")

        delta = total_fixed - total_new
        if delta > 0:
            lines.append(f"🎉 **{delta} more errors fixed than introduced this week!**")
        elif delta < 0:
            lines.append(
                f"⚠️ **{abs(delta)} more errors introduced than fixed this week.**"
            )
        else:
            lines.append("➖ **No net change in total errors.**")
        lines.append("")

    lines.append("---")
    lines.append(f"*Report generated on {today}*")
    lines.append("")

    return "\n".join(lines)


# ── Main ─────────────────────────────────────────────────────────────────────


def main():
    parser = argparse.ArgumentParser(description="Compare gccrs weekly error logs")
    parser.add_argument(
        "--core-log", required=True, help="Path to current core error log"
    )
    parser.add_argument(
        "--kernel-log", required=True, help="Path to current kernel error log"
    )
    parser.add_argument("--gccrs-commit", default="unknown", help="gccrs commit hash")
    parser.add_argument("--gccrs-ref", default="main", help="gccrs branch/tag")
    parser.add_argument("--output", default="report.md", help="Output report path")
    parser.add_argument(
        "--first-run", action="store_true", help="Force first-run mode (no comparison)"
    )
    parser.add_argument(
        "--prev-date",
        default=None,
        help="Specific previous date dir to compare against",
    )
    args = parser.parse_args()

    # Parse current error logs
    print(f"Parsing core errors from: {args.core_log}")
    core_errors = parse_error_log(args.core_log)
    # Filter to only errors and fatal errors for comparison
    core_errors = [b for b in core_errors if b["kind"] in ("error", "fatal error")]
    print(f"  → {len(core_errors)} errors found")

    print(f"Parsing kernel errors from: {args.kernel_log}")
    kernel_errors = parse_error_log(args.kernel_log)
    kernel_errors = [b for b in kernel_errors if b["kind"] in ("error", "fatal error")]
    print(f"  → {len(kernel_errors)} errors found")

    # Try to get previous logs
    prev_core_errors: List[dict] = []
    prev_kernel_errors: List[dict] = []
    prev_date: Optional[str] = None
    is_first_run = args.first_run

    if not is_first_run:
        dates = get_previous_dates()

        if args.prev_date:
            prev_date = args.prev_date
        elif dates:
            prev_date = dates[0]  # Most recent
        else:
            is_first_run = True

        if prev_date:
            print(f"Comparing against previous run: {prev_date}")
            core_text = read_previous_log(prev_date, "core_errors.txt")
            kernel_text = read_previous_log(prev_date, "kernel_errors.txt")

            if core_text:
                prev_core_errors = extract_errors_from_text(core_text)
                prev_core_errors = [
                    b for b in prev_core_errors if b["kind"] in ("error", "fatal error")
                ]
                print(f"  → {len(prev_core_errors)} previous core errors")
            if kernel_text:
                prev_kernel_errors = extract_errors_from_text(kernel_text)
                prev_kernel_errors = [
                    b
                    for b in prev_kernel_errors
                    if b["kind"] in ("error", "fatal error")
                ]
                print(f"  → {len(prev_kernel_errors)} previous kernel errors")

            if not core_text and not kernel_text:
                print("Warning: Could not read previous logs; treating as first run")
                is_first_run = True
        else:
            is_first_run = True

    if is_first_run:
        print("No previous data found — establishing baseline")

    # Generate report
    report = generate_report(
        core_errors=core_errors,
        kernel_errors=kernel_errors,
        prev_core_errors=prev_core_errors,
        prev_kernel_errors=prev_kernel_errors,
        prev_date=prev_date,
        gccrs_commit=args.gccrs_commit,
        gccrs_ref=args.gccrs_ref,
        is_first_run=is_first_run,
    )

    with open(args.output, "w", encoding="utf-8") as fh:
        fh.write(report)

    print(f"\nReport written to: {args.output}")


if __name__ == "__main__":
    main()
