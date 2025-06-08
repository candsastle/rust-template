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
  in {
    devShells = {
      ${linuxSystem}.default = pkgs.mkShell rec {
        nativeBuildInputs = with pkgs; [
          pkg-config
          openssl
          libxkbcommon
          wayland
        ];
        buildInputs = with pkgs; [
          rustup
        ];

        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (buildInputs ++ nativeBuildInputs);
      };
      # No idea if this Mac config actually works
      ${macSystem}.default = pkgs-mac.mkShell rec {
        nativeBuildInputs = with pkgs-mac; [
          pkg-config
          openssl
          libxkbcommon
          wayland
        ];
        buildInputs = with pkgs-mac; [
          rustup
        ];

        LD_LIBRARY_PATH = pkgs-mac.lib.makeLibraryPath (buildInputs ++ nativeBuildInputs);
      };
    };
  };
}
