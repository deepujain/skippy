#!/usr/bin/env bash
# Compatibility facade for the Cursor-specific legacy sweep runner.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
exec "$ROOT/integrations/cursor/scripts/sweep-run-skippy.sh" "$@"
