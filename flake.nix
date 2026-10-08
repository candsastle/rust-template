{
  description = "Rust development shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        isLinux = pkgs.stdenv.isLinux;
        isDarwin = pkgs.stdenv.isDarwin;
        rustChannel = (fromTOML (builtins.readFile ./rust-toolchain.toml)).toolchain.channel;
        libraryPackages = with pkgs;
          [openssl]
          ++ pkgs.lib.optionals isLinux [libxkbcommon wayland];
        libclang = pkgs.llvmPackages_latest.libclang;
        rustTriple =
          if isDarwin
          then
            (
              if pkgs.stdenv.hostPlatform.isAarch64
              then "aarch64-apple-darwin"
              else "x86_64-apple-darwin"
            )
          else "x86_64-unknown-linux-gnu";
        bindgenExtraArgs = with pkgs;
          [
            "-I${libclang.lib}/lib/clang/${libclang.version}/include"
            "-I${glib.dev}/include/glib-2.0"
            "-I${glib.out}/lib/glib-2.0/include"
          ]
          ++ pkgs.lib.optionals isLinux ["-I${glibc.dev}/include"];
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            clang
            llvmPackages.bintools
            pkg-config
            rustup
          ];

          RUSTC_VERSION = rustChannel;
          LIBCLANG_PATH = "${libclang.lib}/lib";
          BINDGEN_EXTRA_CLANG_ARGS = builtins.concatStringsSep " " bindgenExtraArgs;

          shellHook = ''
            export PATH="$PATH:''${CARGO_HOME:-$HOME/.cargo}/bin"
            export PATH="$PATH:''${RUSTUP_HOME:-$HOME/.rustup}/toolchains/$RUSTC_VERSION-${rustTriple}/bin"
            ${
              if isLinux
              then "export LD_LIBRARY_PATH=\"${pkgs.lib.makeLibraryPath libraryPackages}\""
              else "export DYLD_LIBRARY_PATH=\"${pkgs.lib.makeLibraryPath libraryPackages}\""
            }
            if ! rustup component list --toolchain "$RUSTC_VERSION" --installed | grep -q '^rust-analyzer-' || ! rustup component list --toolchain "$RUSTC_VERSION" --installed | grep -q '^rustfmt-' || ! rustup component list --toolchain "$RUSTC_VERSION" --installed | grep -q '^clippy-'; then
              rustup component add --toolchain "$RUSTC_VERSION" rust-analyzer rustfmt clippy
            fi
          '';
        };
      };
    };
}
