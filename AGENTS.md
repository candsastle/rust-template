# Agent guidance

## Working in this repository

- Keep changes focused, preserve existing user work, and use project conventions.
- See [`.agents/rules/rust.md`](.agents/rules/rust.md) for Rust-specific language, dependency, build-environment, and validation guidance.

## Durable agent knowledge

- At the end of every thread, identify any nontrivial, reusable repository rules, workflows, or skills learned while doing the work. If there are any, record them in the most focused appropriate file under `.agents/rules/` or `.agents/skills/`; update an existing file rather than duplicating guidance.
- Do not record transient task details, one-off conclusions, generated output, personal information, credentials, tokens, or other secrets. Do not create guidance merely to document routine or obvious facts. If no durable insight was learned, make no addition.
- Keep each guidance file narrowly scoped, actionable, and consistent with the repository. Link to related guidance from this file or the relevant index when useful.
- Before adding or changing durable guidance, inspect the existing `.agents/` content and avoid overwriting unrelated work.
