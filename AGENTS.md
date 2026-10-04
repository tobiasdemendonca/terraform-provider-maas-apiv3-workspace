## Project map

This directory is a **development workspace**, not the product repository.

Product work happens only in `./terraform-provider-maas-APIv3`. The other trees are reference clones so agents can compare APIv3 (MAAS), the old APIv2 provider, and `gomaasclient`. Never commit in the reference clones as part of this project.

| Path | Role |
|---|---|
| `./terraform-provider-maas-APIv3` | **Writable.** New Terraform provider for MAAS APIv3. Own git repo, own PRs. |
| `./maas` | **Reference.** MAAS source (APIv3 and APIv2). Do not commit. |
| `./terraform-provider-maas` | **Reference.** Old APIv2 Terraform provider. Do not commit. |
| `./gomaasclient` | **Reference.** Hand-maintained Go client used by the old provider. The APIv3 provider generates its client from the OpenAPI spec. Do not commit. |

Workspace-level git (this repo) only tracks agent instructions, skills, bootstrap, and clone URLs. Nested directories are independent git repos and are gitignored here.

After clone: `./scripts/bootstrap.sh` (see `README.md`). Nested repos follow the branches in `repos.conf`, not pinned SHAs. Optional sandboxed toolchain: Canonical Workshop — `workshop launch` then `workshop run -- build`. Definitions live in `.workshop/`; never commit `.workshop.lock`.

## Connect to MAAS

MAAS is already running **outside** this workspace and outside Workshop. Do not launch MAAS in the sandbox. Put credentials in a gitignored `.env` at this workspace root (copy `.env.example`). Never put secrets in this file.

Required:

- `MAAS_API_URL` — e.g. `http://10.10.0.28:5240/MAAS/`
- `MAAS_API_KEY` — consumer:token:secret

Optional (current provider acceptance tests still log in with user/password):

- `MAAS_USERNAME`
- `MAAS_PASSWORD`

`scripts/with-maas-env.sh` loads `.env` and also exports `TF_MAAS_URL`, `TF_MAAS_USER`, and `TF_MAAS_PWD` for `make testacc`. Workshop actions `test` and `testacc` use that wrapper. The project mount makes `.env` visible at `/project/.env` inside the workshop.

Provider implementation rules: `./terraform-provider-maas-APIv3/AGENTS.md`.
Resource workflow: `.agents/skills/create-resource/SKILL.md`.

## Git (this workspace repo)

Use [Conventional Commits](https://www.conventionalcommits.org/) for every commit **and** every pull request title. The PR title is the merge subject; it must be a conventional commit, not a sentence.

Format: `type(optional-scope): short description`

- Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`
- Scopes when useful: `bootstrap`, `skills`, `agents`, `workshop`
- Description: lowercase, imperative, no trailing period
- Branches: `type/short-kebab` (e.g. `chore/follow-default-branches`). Do not use untyped names like `drop-version-pins`.

Examples:

- `chore(bootstrap): clone nested repos on default branches`
- `docs: require conventional commits for PRs`
- `feat(workshop): add Canonical Workshop definition`

Product work in `./terraform-provider-maas-APIv3` follows that repository's own commit conventions, not this section.
