{
  description = "A Nix-flake-based Purescript development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    easy-purescript-nix = {
      url = "github:justinwoo/easy-purescript-nix";
      flake = false;
    };
  };

  outputs = inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import inputs.nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_latest
            purescript
            spago
          ] ++ (with nodePackages_latest; [
            purescript-language-server
            purs-tidy
          ]);
        };
      });
    };
}
