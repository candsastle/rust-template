# Nix and editor environment

- `flake.nix` defines a Nix development shell for `x86_64-linux`. It provides `rustup`, Clang/LLVM tools, `pkg-config`, and native libraries/headers used by builds, including OpenSSL, Wayland, and libxkbcommon.
- The shell derives the Rust channel from `rust-toolchain.toml` and adds `rust-analyzer`, `rustfmt`, and `clippy`. Prefer the existing shell for reproducible project development instead of assuming host-installed native dependencies.
- `.zed/settings.json` enables rust-analyzer, formats Rust on save with `rustfmt --edition 2024`, and uses Clippy for checks. `.helix/languages.toml` enables Rust auto-formatting and configures rust-analyzer.
- Do not modify `flake.nix`, `flake.lock`, `.zed/`, or `.helix/` for unrelated work. Make environment/editor changes only when requested, and keep corresponding tools and versions aligned with the Rust toolchain.
