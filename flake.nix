{
  description = "Rust development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    rustChannel = (fromTOML (builtins.readFile ./rust-toolchain.toml)).toolchain.channel;
    libraryPackages = with pkgs; [
      openssl
      libxkbcommon
      wayland
    ];
    libclang = pkgs.llvmPackages_latest.libclang;
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        clang
        llvmPackages.bintools
        pkg-config
        rustup
      ];

      RUSTC_VERSION = rustChannel;
      LIBCLANG_PATH = "${libclang.lib}/lib";
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libraryPackages;
      BINDGEN_EXTRA_CLANG_ARGS = builtins.concatStringsSep " " [
        ''-I${pkgs.glibc.dev}/include''
        ''-I${libclang.lib}/lib/clang/${libclang.version}/include''
        ''-I${pkgs.glib.dev}/include/glib-2.0''
        ''-I${pkgs.glib.out}/lib/glib-2.0/include''
      ];

      shellHook = ''
        export PATH="$PATH:''${CARGO_HOME:-$HOME/.cargo}/bin"
        export PATH="$PATH:''${RUSTUP_HOME:-$HOME/.rustup}/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin"
        rustup component add rust-analyzer rustfmt clippy
      '';
    };
  };
}
