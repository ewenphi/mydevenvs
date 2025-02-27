{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    mydevenvs = {
      global = {
        hooks.enable = lib.mkOption {
          default = true;
          example = false;
          description = "Whether to enable or disable all hooks enabled.";
          type = lib.types.bool;
        };
        languages.enable = lib.mkOption {
          default = true;
          example = false;
          description = "Whether to enable or disable all language support enabled.";
          type = lib.types.bool;
        };
        enterTest.enable = lib.mkOption {
          default = true;
          example = false;
          description = "Whether to enable or disable all tests enabled.";
          type = lib.types.bool;
        };
        packages.enable = lib.mkOption {
          default = true;
          example = false;
          description = "Whether to enable or disable all packages enabled.";
          type = lib.types.bool;
        };
        env.enable = lib.mkOption {
          default = true;
          example = false;
          description = "Whether to enable or disable all environment variables enabled.";
          type = lib.types.bool;
        };
        scripts.enable = lib.mkOption {
          default = true;
          example = false;
          description = "Whether to enable or disable all scripts enabled.";
          type = lib.types.bool;
        };
      };
      nix = {
        enable = lib.mkEnableOption "enable nix devenv";
        flake.enable = lib.mkEnableOption "enable flake";
        check.enable = lib.mkEnableOption "add the package to the test";
        check.package = lib.mkPackageOption pkgs "default-package" {
          default = null;
          nullable = true;
          example = "config.packages.default";
          extraDescription = "A package produced by you to be added in the checks";
        };
      };
    };
  };

  config = lib.mkIf config.mydevenvs.nix.enable {
    languages.nix.enable = lib.mkIf config.mydevenvs.global.languages.enable true;

    git-hooks.hooks = lib.mkIf config.mydevenvs.global.hooks.enable {
      nixfmt-rfc-style.enable = true;
      statix.enable = true;
      deadnix.enable = true;
      deadnix.settings.edit = true;
      commitizen.enable = true;
      flake-checker.enable = lib.mkIf config.mydevenvs.nix.flake.enable true;
      flake-checker.entry = "${config.git-hooks.hooks.flake-checker.package}/bin/flake-checker -f --no-telemetry";
    };

    packages = lib.mkIf config.mydevenvs.global.packages.enable [
      pkgs.nil
    ];

    #not nix related, for nix flake check to work
    containers = lib.mkOverride 80 { };
  };
}
