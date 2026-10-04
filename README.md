# MAAS APIv3 Terraform provider workspace

Shared **development workspace** for the MAAS APIv3 Terraform provider. This repository does not contain the provider source. It versions the agent instructions, skills, and a bootstrap that clones the sibling repos.

## Layout

| Path | Git | Purpose |
|---|---|---|
| (this repo) | this repository | `AGENTS.md`, skills, bootstrap, `repos.conf`, `.workshop/` |
| `terraform-provider-maas-APIv3/` | [tobiasdemendonca/terraform-provider-maas-APIv3](https://github.com/tobiasdemendonca/terraform-provider-maas-APIv3) | Product. Only place to commit provider code. |
| `maas/` | [canonical/maas](https://github.com/canonical/maas) | Reference. Do not commit. |
| `terraform-provider-maas/` | [canonical/terraform-provider-maas](https://github.com/canonical/terraform-provider-maas) | Reference (APIv2 provider). Do not commit. |
| `gomaasclient/` | [canonical/gomaasclient](https://github.com/canonical/gomaasclient) | Reference. Do not commit. |

## Setup

```bash
git clone <this-workspace-repo>
cd show-and-tell-workspace   # or whatever you named the clone
./scripts/bootstrap.sh
cp .env.example .env         # if bootstrap did not already copy it
# set MAAS_API_URL and MAAS_API_KEY for the already-running MAAS
```

Open this folder (or `maas-apiv3.code-workspace`) in Cursor.

`bootstrap.sh` clones any missing nested repos onto the branches in `repos.conf` (`main` for the APIv3 provider, `master` for the Canonical trees). Existing checkouts are left alone so local branches are not moved. To fast-forward those default branches (clean trees only, and only if you are already on that branch):

```bash
./scripts/bootstrap.sh --update
```

There is no SHA lockfile. Each nested repo tracks its remote branch, so colleagues get whatever is current when they clone or update.

## Canonical Workshop

The sandboxed toolchain is a [Canonical Workshop](https://ubuntu.com/workshop) (`dev` in `.workshop/dev.yaml`). Prerequisites: [LXD 6.8+](https://ubuntu.com/workshop/docs/tutorial/part-1-get-started/) and `sudo snap install --classic workshop`.

MAAS is **not** part of the workshop. Point `.env` at the existing instance (`MAAS_API_URL` and `MAAS_API_KEY`). Workshop actions source that file via `scripts/with-maas-env.sh`.

```bash
./scripts/bootstrap.sh
cp .env.example .env   # set MAAS_API_URL and MAAS_API_KEY
workshop launch
workshop exec -- go version
workshop run -- build
workshop run -- testacc
workshop shell
```

Go tracks `1.25/stable` (matches the provider `go.mod`). Terraform comes from the Store SDK `terraform-papagr`. `make`, `python3`, and `git` are installed by the in-project `project-tools` SDK. After changing SDKs or the base, run `workshop refresh`. Do not commit `.workshop.lock`.

## Where to commit

- Provider features, tests, OpenAPI client: inside `terraform-provider-maas-APIv3/`
- Skills, `AGENTS.md`, bootstrap, `repos.conf`, `.workshop/`: this workspace repo
- Never: `maas/`, `terraform-provider-maas/`, `gomaasclient/`

## Pull requests and commits

This workspace uses [Conventional Commits](https://www.conventionalcommits.org/) for commit messages, PR titles, and new branch names (`type/short-kebab`). See `AGENTS.md`.

## Credentials

`.env` is gitignored. Do not put API keys in `AGENTS.md`.
