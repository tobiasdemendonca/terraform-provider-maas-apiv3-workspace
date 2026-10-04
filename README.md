# MAAS APIv3 Terraform provider workspace

Shared **development workspace** for the MAAS APIv3 Terraform provider. This repository does not contain the provider source. It versions the agent instructions, skills, and a bootstrap that clones the sibling repos.

## Layout

| Path | Git | Purpose |
|---|---|---|
| (this repo) | this repository | `AGENTS.md`, skills, bootstrap, `repos.conf` |
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
# edit .env with a real MAAS API key
```

Open this folder (or `maas-apiv3.code-workspace`) in Cursor.

`bootstrap.sh` clones any missing nested repos onto the branches in `repos.conf` (`main` for the APIv3 provider, `master` for the Canonical trees). Existing checkouts are left alone so local branches are not moved. To fast-forward those default branches (clean trees only, and only if you are already on that branch):

```bash
./scripts/bootstrap.sh --update
```

There is no SHA lockfile. Each nested repo tracks its remote branch, so colleagues get whatever is current when they clone or update.

## Where to commit

- Provider features, tests, OpenAPI client: inside `terraform-provider-maas-APIv3/`
- Skills, `AGENTS.md`, bootstrap, `repos.conf`: this workspace repo
- Never: `maas/`, `terraform-provider-maas/`, `gomaasclient/`

## Pull requests and commits

This workspace uses [Conventional Commits](https://www.conventionalcommits.org/) for commit messages, PR titles, and new branch names (`type/short-kebab`). See `AGENTS.md`.

## Credentials

`.env` is gitignored. Do not put API keys in `AGENTS.md`.
