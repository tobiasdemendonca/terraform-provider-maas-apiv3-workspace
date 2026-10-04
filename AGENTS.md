## Project map

This directory is a **development workspace**, not the product repository.

Product work happens only in `./terraform-provider-maas-APIv3`. The other trees are reference clones so agents can compare APIv3 (MAAS), the old APIv2 provider, and `gomaasclient`. Never commit in the reference clones as part of this project.

| Path | Role |
|---|---|
| `./terraform-provider-maas-APIv3` | **Writable.** New Terraform provider for MAAS APIv3. Own git repo, own PRs. |
| `./maas` | **Reference.** MAAS source (APIv3 and APIv2). Do not commit. |
| `./terraform-provider-maas` | **Reference.** Old APIv2 Terraform provider. Do not commit. |
| `./gomaasclient` | **Reference.** Hand-maintained Go client used by the old provider. The APIv3 provider generates its client from the OpenAPI spec. Do not commit. |

Workspace-level git (this repo) only tracks agent instructions, skills, bootstrap, and lockfile. Nested directories are independent git repos and are gitignored here.

After clone: `./scripts/bootstrap.sh` (see `README.md`). Pin SHAs live in `versions.lock`.

## Connect to MAAS

Credentials are environment variables, loaded from a gitignored `.env` at this workspace root (copy `.env.example`). Never put secrets in this file.

- `MAAS_API_URL`
- `MAAS_API_KEY`
- `MAAS_USERNAME`
- `MAAS_PASSWORD`

Provider implementation rules: `./terraform-provider-maas-APIv3/AGENTS.md`.
Resource workflow: `.agents/skills/create-resource/SKILL.md`.
