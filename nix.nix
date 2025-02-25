{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    devenvs = {
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
      };
    };
  };

  config = lib.mkIf config.devenvs.nix.enable {
    languages.nix.enable = lib.mkIf config.devenvs.global.languages.enable true;

    git-hooks.hooks = lib.mkIf config.devenvs.global.hooks.enable {
      nixfmt-rfc-style.enable = true;
      statix.enable = true;
      deadnix.enable = true;
      deadnix.settings.edit = true;
      commitizen.enable = true;
      flake-checker.enable = lib.mkIf config.devenvs.nix.flake.enable true;
    };

    packages = lib.mkIf config.devenvs.global.packages.enable [
      pkgs.nil
    ];

    #not nix related, for nix flake check to work
    containers = lib.mkOverride 80 { };
  };
}
