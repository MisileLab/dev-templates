{
  description = "A Nix-flake-based R development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      overlays = [
        (final: prev: rec {
          rEnv = prev.rWrapper.override {
            packages = with prev.rPackages; [ knitr ];
          };
        })
      ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs;
            [
              rEnv
              pandoc
              texlive.combined.scheme-full
            ];
        };
      });
    };
}
