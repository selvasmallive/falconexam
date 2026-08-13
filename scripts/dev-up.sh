#!/usr/bin/env bash
#
# Starts the FalconExam local development environment: PostgreSQL, Redis, the Cloud Storage
# emulator and the mail catcher. Waits for every service to report healthy.
#
# Milestone 1 acceptance requires the local environment to start with one command; this is it.
#
#   ./scripts/dev-up.sh [--recreate]

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed or not on PATH. Install Docker Desktop and try again." >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker is installed but not running. Start Docker Desktop and try again." >&2
  exit 1
fi

if [[ ! -f .env ]]; then
  echo "No .env found - creating one from .env.example"
  cp .env.example .env
fi

compose_args=(compose up -d --wait)
if [[ "${1:-}" == "--recreate" ]]; then
  compose_args+=(--force-recreate)
fi

echo "Starting FalconExam backing services..."
docker "${compose_args[@]}"

# Read ports back from .env so the printed URLs match what was actually published.
get_port() {
  local key="$1" default="$2" value
  value="$(grep -E "^\s*${key}\s*=" .env | tail -n 1 | cut -d= -f2- | tr -d '[:space:]' || true)"
  echo "${value:-$default}"
}

cat <<EOF

FalconExam local environment is up.
  PostgreSQL        localhost:$(get_port POSTGRES_PORT 5432)
  Redis             localhost:$(get_port REDIS_PORT 6379)
  Storage emulator  http://localhost:$(get_port STORAGE_PORT 4443)
  Mail UI           http://localhost:$(get_port MAIL_UI_PORT 8025)

Application services (api, ai, web) arrive with Milestone 1.
Stop everything with ./scripts/dev-down.sh
EOF
