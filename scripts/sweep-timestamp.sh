#!/usr/bin/env bash
# Log timestamps for Skippy sweep output (human-readable, US Pacific).
# Uses America/Los_Angeles so labels are PST in winter and PDT in summer.
# Override with SKIPPY_LOG_TZ if needed.
set -euo pipefail
TZ="${SKIPPY_LOG_TZ:-America/Los_Angeles}"
export TZ
date '+%Y-%m-%dT%H:%M:%S %Z'
