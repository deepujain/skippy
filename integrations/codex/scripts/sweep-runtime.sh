#!/usr/bin/env bash
# Codex adapter for the shared Skippy sweep runtime.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
exec "$ROOT/scripts/sweep-runtime.sh" "$@"
