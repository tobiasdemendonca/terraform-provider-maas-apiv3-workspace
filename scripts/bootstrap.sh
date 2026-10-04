#!/usr/bin/env bash
# Clone or update the nested product/reference repos listed in repos.conf.
# There is no SHA pin: clones follow each repo's default branch (latest at clone/pull time).
#
# Default: clone missing directories only. Existing checkouts are left as-is.
#   ./scripts/bootstrap.sh
#
# Fast-forward the listed branch in each clean checkout:
#   ./scripts/bootstrap.sh --update
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONF="${ROOT}/repos.conf"
UPDATE=0

if [[ "${1:-}" == "--update" ]]; then
  UPDATE=1
elif [[ "${1:-}" != "" ]]; then
  echo "usage: $0 [--update]" >&2
  exit 2
fi

if [[ ! -f "${CONF}" ]]; then
  echo "missing ${CONF}" >&2
  exit 1
fi

dirty() {
  local dest="$1"
  [[ -n "$(git -C "${dest}" status --porcelain)" ]]
}

clone_or_update() {
  local name="$1" path="$2" url="$3" branch="$4" role="$5"
  local dest="${ROOT}/${path}"

  if [[ ! -d "${dest}/.git" ]]; then
    echo "cloning ${name} (${role}) -> ${path} (${branch})"
    git clone --branch "${branch}" "${url}" "${dest}"
    echo "cloned ${name} at $(git -C "${dest}" rev-parse --short HEAD)"
    return
  fi

  local current head
  current="$(git -C "${dest}" rev-parse --abbrev-ref HEAD)"
  head="$(git -C "${dest}" rev-parse --short HEAD)"
  echo "${name}: present on ${current} at ${head} (tracks ${branch}, role ${role})"

  if [[ "${UPDATE}" != 1 ]]; then
    return
  fi

  if dirty "${dest}"; then
    echo "skipping --update for ${name}: working tree is dirty" >&2
    return
  fi

  git -C "${dest}" fetch --all --prune

  if [[ "${current}" != "${branch}" ]]; then
    echo "skipping --update for ${name}: on ${current}, not ${branch}" >&2
    return
  fi

  git -C "${dest}" pull --ff-only
  echo "updated ${name} to $(git -C "${dest}" rev-parse --short HEAD)"
}

while IFS=$'\t' read -r name path url branch role || [[ -n "${name:-}" ]]; do
  [[ -z "${name}" || "${name}" == \#* ]] && continue
  clone_or_update "${name}" "${path}" "${url}" "${branch}" "${role}"
done < "${CONF}"

if [[ ! -f "${ROOT}/.env" && -f "${ROOT}/.env.example" ]]; then
  cp "${ROOT}/.env.example" "${ROOT}/.env"
  echo "wrote .env from .env.example — fill in MAAS credentials"
fi

echo "bootstrap complete"
