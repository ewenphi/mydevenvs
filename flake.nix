{
  description = "my devenvs modules for my dev setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    advisory-db = {
      url = "github:rustsec/advisory-db";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, flake-parts-lib, ... }:
      let
        inherit (flake-parts-lib) importApply;
        flakeModules.default = importApply ./flake-module.nix { inherit withSystem; };
      in
      {
        imports = [
          inputs.flake-parts.flakeModules.flakeModules
          inputs.devenv.flakeModule
          flakeModules.default
        ];
        systems = [
          "x86_64-linux"
          "x86_64-darwin"
        ];
        perSystem = _: {
          devenv.shells.default = {
            devenvs.nix.enable = true;
            devenvs.nix.flake.enable = true;
          };
        };
        flake = {
          inherit flakeModules;
          flakeModule = flakeModules.default;

        };
      }
    );
}
