#!/usr/bin/env python3
"""Cursor adapter for the shared Skippy sweep watchdog."""
from __future__ import annotations

import os
import sys
from pathlib import Path


root = Path(__file__).resolve().parents[3]
os.execv(str(root / "scripts" / "sweep-watchdog.py"), ["sweep-watchdog.py", *sys.argv[1:]])
