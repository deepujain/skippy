#!/usr/bin/env python3
"""Report queued or active project sweep owners that exceeded runtime limits."""
from __future__ import annotations

import argparse
import datetime as dt
import json
from pathlib import Path


PROJECTS = ("skillspector", "nemoclaw", "inspect-ai", "hadoop", "airflow", "superset")


def age_seconds(timestamp: str, now: dt.datetime) -> int:
    updated = dt.datetime.fromisoformat(timestamp)
    return max(0, int((now - updated).total_seconds()))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("run_id")
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--startup-seconds", type=int, default=180)
    parser.add_argument("--active-seconds", type=int, default=5400)
    parser.add_argument("--project", action="append", dest="projects")
    args = parser.parse_args()

    now = dt.datetime.now(dt.timezone.utc)
    needs_action = False
    for project in args.projects or PROJECTS:
        checkpoint = args.root / args.run_id / project / "checkpoint.json"
        if not checkpoint.exists():
            print(f"{project}\tmissing\tREPLACE\tno checkpoint")
            needs_action = True
            continue

        payload = json.loads(checkpoint.read_text(encoding="utf-8"))
        age = age_seconds(payload["updated_at"], now)
        state = payload.get("state", "unknown")
        phase = payload.get("phase", "unknown")
        if state == "prepared" and age > args.startup_seconds:
            action = "REPLACE"
            needs_action = True
        elif state == "active" and age > args.active_seconds:
            action = "HANDOFF"
            needs_action = True
        else:
            action = "OK"
        print(f"{project}\t{phase}/{state}\t{action}\tage={age}s")

    return 2 if needs_action else 0


if __name__ == "__main__":
    raise SystemExit(main())
