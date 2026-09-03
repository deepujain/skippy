#!/usr/bin/env python3
"""Format sweep summary rows as a fixed-width box table for plain-text logs."""
from __future__ import annotations

import json
import sys
import textwrap


def _clip(text: str, width: int, marker: str = "...") -> str:
    text = str(text)
    if width <= 0:
        return ""
    if len(text) <= width:
        return text
    if width <= len(marker):
        return marker[:width]
    return text[: width - len(marker)] + marker


def _wrap_cell(text: str, width: int, max_lines: int = 2) -> list[str]:
    lines = textwrap.wrap(
        str(text),
        width=width,
        break_long_words=True,
        break_on_hyphens=False,
        replace_whitespace=True,
    ) or [""]
    if len(lines) > max_lines:
        lines = lines[:max_lines]
        lines[-1] = _clip(lines[-1] + "...", width)
    return lines


def format_table(headers: list[str], rows: list[list[str]], caps: list[int]) -> str:
    widths = []
    for i, header in enumerate(headers):
        cap = caps[i] if i < len(caps) else 30
        content_max = max((len(str(row[i])) for row in rows), default=0)
        widths.append(min(max(len(header), content_max), cap))

    def sep() -> str:
        return "+-" + "-+-".join("-" * w for w in widths) + "-+"

    def row(cells: list[str]) -> list[str]:
        wrapped = [_wrap_cell(cell, width) for cell, width in zip(cells, widths)]
        height = max(len(lines) for lines in wrapped)
        return [
            "| "
            + " | ".join(
                (lines[line_index] if line_index < len(lines) else "").ljust(width)
                for lines, width in zip(wrapped, widths)
            )
            + " |"
            for line_index in range(height)
        ]

    lines = [sep(), *row(headers), sep()]
    for entry in rows:
        lines.extend(row(entry))
    lines.append(sep())
    return "\n".join(lines)


def main() -> int:
    payload = json.load(sys.stdin)
    headers = payload["headers"]
    rows = payload["rows"]
    caps = payload.get(
        "caps",
        [12, 6, 9, 24, 48, 52],
    )
    print(format_table(headers, rows, caps))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
