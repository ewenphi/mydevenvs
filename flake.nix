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
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.flakeModules
        inputs.devenv.flakeModule
      ];
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      perSystem = _: {
        devenv.shells.default = {
          imports = [ ./nix.nix ];
          nix.enable = true;
          nix.flake.enable = true;
        };
      };
      flake = {
        flakeModule = {
          default = import ./default.nix;
        };
      };
    };
}
