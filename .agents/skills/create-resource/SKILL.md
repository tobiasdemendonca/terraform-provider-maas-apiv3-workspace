---
name: create-resource
description: Add a new Terraform resource to the provider.
---

You will be assisting to implement a new Terraform resource for the MAAS provider. Your ultimate objective is to write the simplest implementation of a new resource possible that matches every single criterion in the users design plan.

Follow these steps in order after reading this file:

1. Ask the user to provide a resource name and any additional design considerations for the resource. The resource name should be in snake_case (e.g. `network_interface`, `subnet`).

2. Review ./terraform-provider-maas-APIv3/AGENTS.md for principles on how to build resources and features in general

3. Check for any existing implementation in the old provider, and if it exists, note that it may or may not be a good reference for the new provider. Some behaviour may have changed between APIv2 and APIv3. 

4. Check the MAAS source code for the APIv3 implementation, and note any differences in behaviour from the old provider.

5. **Suggest the resource name** — suggest to the user the resource name in snake_case (e.g. `network_interface`, `subnet`), and a short description of the design concept for the resource. 

6. **Regenerate the client** — run `make generate-client`. This converts the OpenAPI spec and regenerates `internal/client/maasclientv3/client.gen.go` which might have been updated. Fix any errors in `scripts/fix-openapi-nullable.py` rather than editing generated files.

7. Explore the `api/generated/openapi.json` and `internal/client/maasclientv3/client.gen.go` files to understand the available API endpoints and data structures. 

8. Execute the grill-me skill found in `.agents/skills/grill-me/` to stress-test and form a clear resource design picture.
   
9. Write a plan and show me the plan before asking if it needs to be revised before executing the next steps. The plan should include:
   - A high-level outline of the resource schema (the attributes it will have).
   - Any special considerations or edge cases that need to be handled in the implementation.
   - You should reach an agreement on the plan with the user before proceeding to the next steps.

10. **Scaffold the resource** — run `make scaffold-resource NAME=<name>` (using the snake_case name). This creates `internal/provider/<name>_resource.go`.

11. **Register the resource** — add `New<Name>Resource` to the slice in `Resources()` in `internal/provider/provider.go`, following the existing `NewTagResource` pattern.

12. **Implement the resource** — fill in the scaffolded file:
   - Map all create/read/update/delete operations through the generated client
   - Follow the **CRUD implementation** and **Nullability** sections in `AGENTS.md` (rationale in `docs/decisions/0003` and `0004`). `internal/provider/fabric_resource.go` is the exemplar (don't compare in comments with it in other resources).

13. **Verify** — Run `make lint fmt`, then `make build` to verify it compiles. Run `make create-dev-overrides` and export the relevant output variable to your shell.

14. **Example** — Add 1 or more examples of the resource in `.devenv/main.tf` that tests its functionality for the user's own QA. Don't perform QA yourself, use the tests in the next step.

15. **Test** — Write acceptance tests following the **Acceptance testing** section in `AGENTS.md` (rationale in `docs/decisions/0005`), with `internal/provider/fabric_resource_test.go` as the exemplar (don't compare in comments with it in other resources).

16. Run the unit and acceptance tests, do a final review of the code and edge cases. 
