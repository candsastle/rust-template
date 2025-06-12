{
  description = "Template Flake For Rust Projects";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };
  outputs = {self, ...} @ inputs: let
    linuxSystem = "x86_64-linux";
    macSystem = "aarch64-darwin";
    pkgs = inputs.nixpkgs.legacyPackages.${linuxSystem};
    pkgs-mac = inputs.nixpkgs.legacyPackages.${macSystem};
    overrides = builtins.fromTOML (builtins.readFile ./rust-toolchain.toml);
  in {
    devShells = let
      libPath = pkgs.lib.makeLibraryPath libraryPackages;
      libraryPackages = with pkgs; [
        pkg-config
        openssl
        libxkbcommon
        wayland
      ];
    in {
      ${linuxSystem}.default = pkgs.mkShell {
        buildInputs = with pkgs; [clang llvmPackages.bintools rustup];
        RUSTC_VERSION = overrides.toolchain.channel;

        LIBCLANG_PATH = pkgs.lib.makeLibraryPath [pkgs.llvmPackages_latest.libclang.lib];
        shellHook = ''
          export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
          export PATH=$PATH:''${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin/
        '';
        # Add precompiled library to rustc search path
        RUSTFLAGS = builtins.map (a: ''-L ${a}/lib'') [
          # add libraries here (e.g. pkgs.libvmi)
        ];
        LD_LIBRARY_PATH = libPath;
        # Add glibc, clang, glib, and other headers to bindgen search path
        BINDGEN_EXTRA_CLANG_ARGS =
          # Includes normal include path
          (builtins.map (a: ''-I"${a}/include"'') [
            # add dev libraries here (e.g. pkgs.libvmi.dev)
            pkgs.glibc.dev
          ])
          # Includes with special directory paths
          ++ [
            ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
            ''-I"${pkgs.glib.dev}/include/glib-2.0"''
            ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
          ];
      };
      # No idea if this Mac config actually works
      ${macSystem}.default = pkgs-mac.mkShell rec {
        nativeBuildInputs = with pkgs-mac; [
          pkg-config
          openssl
          libxkbcommon
          wayland
        ];

        LD_LIBRARY_PATH = pkgs-mac.lib.makeLibraryPath nativeBuildInputs;
      };
    };
  };
}
