# MAAS APIv3 Terraform provider workspace

Shared **development workspace** for the MAAS APIv3 Terraform provider. This repository does not contain the provider source. It versions the agent instructions, skills, and the pinned sibling clones needed to work with agents.

## Layout

| Path | Git | Purpose |
|---|---|---|
| (this repo) | this repository | `AGENTS.md`, skills, bootstrap, `versions.lock` |
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

`bootstrap.sh` clones any missing nested repos and checks them out at the SHAs in `versions.lock`. Existing checkouts are left alone so local branches are not moved. To force checkouts to the lockfile (clean trees only):

```bash
./scripts/bootstrap.sh --sync
```

Bump pins by checking out the desired revision in a nested clone, then putting that SHA in `versions.lock` and committing **this** repo.

## Where to commit

- Provider features, tests, OpenAPI client: inside `terraform-provider-maas-APIv3/`
- Skills, `AGENTS.md`, bootstrap, lockfile: this workspace repo
- Never: `maas/`, `terraform-provider-maas/`, `gomaasclient/`

## Credentials

`.env` is gitignored. Do not put API keys in `AGENTS.md` or the lockfile.
