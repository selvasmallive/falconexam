#!/usr/bin/env bash
#
# Stops the FalconExam local development environment.
#
#   ./scripts/dev-down.sh            stop, keep local data
#   ./scripts/dev-down.sh --purge    stop and delete the named volumes (database, Redis, storage)
#
# --purge is what you want for a clean first-run, including re-running scripts/db/init.

set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${1:-}" == "--purge" ]]; then
  echo "Stopping FalconExam and deleting all local data volumes..."
  docker compose down --volumes --remove-orphans
else
  echo "Stopping FalconExam (local data is preserved)..."
  docker compose down --remove-orphans
fi

echo "Done."
