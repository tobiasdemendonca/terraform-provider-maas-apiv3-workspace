#!/usr/bin/env bash
# Clone or update the nested product/reference repos listed in versions.lock.
#
# Default: clone missing directories only. Existing checkouts are left as-is.
#   ./scripts/bootstrap.sh
#
# Pin existing checkouts to the lockfile revisions (skips dirty trees):
#   ./scripts/bootstrap.sh --sync
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK="${ROOT}/versions.lock"
SYNC=0

if [[ "${1:-}" == "--sync" ]]; then
  SYNC=1
elif [[ "${1:-}" != "" ]]; then
  echo "usage: $0 [--sync]" >&2
  exit 2
fi

if [[ ! -f "${LOCK}" ]]; then
  echo "missing ${LOCK}" >&2
  exit 1
fi

dirty() {
  local dest="$1"
  [[ -n "$(git -C "${dest}" status --porcelain)" ]]
}

clone_or_sync() {
  local name="$1" path="$2" url="$3" revision="$4" role="$5"
  local dest="${ROOT}/${path}"

  if [[ ! -d "${dest}/.git" ]]; then
    echo "cloning ${name} (${role}) -> ${path}"
    git clone "${url}" "${dest}"
    git -C "${dest}" checkout --detach "${revision}"
    echo "checked out ${name} at ${revision}"
    return
  fi

  local current
  current="$(git -C "${dest}" rev-parse HEAD)"
  echo "${name}: present at ${current} (lock ${revision}, role ${role})"

  if [[ "${SYNC}" != 1 ]]; then
    return
  fi

  if dirty "${dest}"; then
    echo "skipping --sync for ${name}: working tree is dirty" >&2
    return
  fi

  git -C "${dest}" fetch --all --prune
  git -C "${dest}" checkout --detach "${revision}"
  echo "synced ${name} to ${revision}"
}

while IFS=$'\t' read -r name path url revision role || [[ -n "${name:-}" ]]; do
  [[ -z "${name}" || "${name}" == \#* ]] && continue
  clone_or_sync "${name}" "${path}" "${url}" "${revision}" "${role}"
done < "${LOCK}"

if [[ ! -f "${ROOT}/.env" && -f "${ROOT}/.env.example" ]]; then
  cp "${ROOT}/.env.example" "${ROOT}/.env"
  echo "wrote .env from .env.example — fill in MAAS credentials"
fi

echo "bootstrap complete"
