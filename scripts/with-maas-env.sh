#!/usr/bin/env bash
# Load gitignored .env and map it for the APIv3 provider.
# MAAS itself runs on the host (or LAN), not inside Workshop.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "${ROOT}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT}/.env"
  set +a
fi

export TF_MAAS_URL="${TF_MAAS_URL:-${MAAS_API_URL:-}}"
export TF_MAAS_USER="${TF_MAAS_USER:-${MAAS_USERNAME:-}}"
export TF_MAAS_PWD="${TF_MAAS_PWD:-${MAAS_PASSWORD:-}}"

if [[ "${#}" -eq 0 ]]; then
  echo "usage: $0 <command> [args...]" >&2
  exit 2
fi

exec "$@"
