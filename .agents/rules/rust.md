# Rust project rules

## Toolchain and validation

- Treat this as a Rust 2024 project using the stable toolchain. Check `Cargo.toml` and `rust-toolchain.toml` before making assumptions about dependencies or toolchain requirements. The toolchain file declares `rust-analyzer`, `rustfmt`, and `clippy`; use edition-compatible language and standard-library APIs.
- Rust sources are formatted with `rustfmt`; the editor setup formats on save. Run `cargo fmt --check` when Rust files change.
- Zed configures rust-analyzer to run Clippy checks. For code changes, prefer `cargo clippy --all-targets` when a lint check is useful, alongside relevant `cargo check` or `cargo test` commands.

## Dependencies and system libraries

- Keep dependencies minimal. Check existing `Cargo.toml` before adding a crate, and update `Cargo.lock` through Cargo when dependency resolution changes.
- If a new feature would greatly benefit from a third-party Rust crate, ask the user whether adding it is acceptable unless they have explicitly allowed or forbidden it. Explain the relevant tradeoffs, such as maintenance, dependency-tree size, compile time, licensing, and what a standard-library or existing-dependency alternative would cost. Do not add the crate before getting approval.
- When the Rust project expects a system library or native build dependency (for example, OpenSSL or Wayland), add it to the appropriate package list in `flake.nix` so the development shell supplies it. Include headers and discovery/build tools where required by the integration.

## Style and refactors

- Prefer functional-style programming over imperative or procedural approaches where it makes the code clear and idiomatic Rust; favor expressions, iterator combinators, and immutable data when appropriate.
- After completing a large refactor, always suggest useful follow-up improvements to the code, such as organization, cleanup, or best-practice changes. Keep these suggestions separate from the completed scope unless the user asks to implement them.
