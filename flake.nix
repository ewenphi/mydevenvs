{
  description = "my devenvs modules for my dev setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    advisory-db = {
      url = "github:rustsec/advisory-db";
      flake = false;
    };
    mkdocs-flake.url = "github:applicative-systems/mkdocs-flake";
    mkdocs-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { flake-parts-lib, ... }:
      let
        inherit (flake-parts-lib) importApply;
        flakeModules.default = importApply ./flake-module.nix {
          inherit inputs;
        };
      in
      {
        imports = [
          inputs.flake-parts.flakeModules.flakeModules
          flakeModules.default
          inputs.devenv.flakeModule
          inputs.mkdocs-flake.flakeModule
        ];
        systems = [
          "x86_64-linux"
          "x86_64-darwin"
        ];
        perSystem =
          { config, ... }:
          {
            devenv.shells.default = {
              devenvs = {
                nix.enable = true;
                nix.flake.enable = true;
                tools = {
                  mkdocs.enable = true;
                  mkdocs.package = config.packages.documentation;
                  just.enable = true;
                  just.pre-commit.enable = true;
                };
              };
            };
            documentation = {
              mkdocs-root = ./.;
              strict = true;
            };
          };
        flake = {
          #flake-parts
          inherit flakeModules;
          flakeModule = flakeModules.default;
          devenv = inputs.devenv.flakeModule;

          #classic module, to import in devenv.shells."yourshell"
          devenvModule = import ./default.nix;

          templates.default = {
            path = ./templates;
            description = "myDevenvs template with flake-parts";
          };
        };
      }
    );
}
