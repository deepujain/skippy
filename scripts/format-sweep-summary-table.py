#!/usr/bin/env python3
"""Format sweep summary rows as a fixed-width box table for plain-text logs."""
from __future__ import annotations

import json
import sys


def _clip(text: str, width: int) -> str:
    text = str(text)
    if width <= 0:
        return ""
    if len(text) <= width:
        return text
    if width == 1:
        return "…"
    return text[: width - 1] + "…"


def format_table(headers: list[str], rows: list[list[str]], caps: list[int]) -> str:
    widths = []
    for i, header in enumerate(headers):
        cap = caps[i] if i < len(caps) else 30
        content_max = max((len(str(row[i])) for row in rows), default=0)
        widths.append(min(max(len(header), content_max), cap))

    def sep() -> str:
        return "+-" + "-+-".join("-" * w for w in widths) + "-+"

    def row(cells: list[str]) -> str:
        return (
            "| "
            + " | ".join(_clip(cell, w).ljust(w) for cell, w in zip(cells, widths))
            + " |"
        )

    lines = [sep(), row(headers), sep()]
    for entry in rows:
        lines.append(row(entry))
    lines.append(sep())
    return "\n".join(lines)


def main() -> int:
    payload = json.load(sys.stdin)
    headers = payload["headers"]
    rows = payload["rows"]
    caps = payload.get(
        "caps",
        [12, 6, 9, 22, 34, 44],
    )
    print(format_table(headers, rows, caps))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
