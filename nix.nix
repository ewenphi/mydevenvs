{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    devenvs.nix = {
      enable = lib.mkEnableOption "enable nix devenv";
      flake.enable = lib.mkEnableOption "enable flake";
      tests.enable = lib.mkEnableOption "nix build in test";
    };
  };

  config = lib.mkIf config.devenvs.nix.enable {
    languages.nix.enable = true;

    git-hooks.hooks =
      {
        nixfmt-rfc-style.enable = true;
        statix.enable = true;
        deadnix.enable = true;
        commitizen.enable = true;
      }
      // lib.attrsets.optionalAttrs config.devenvs.nix.flake.enable {
        flake-checker.enable = true;
      };

    enterTest = lib.mkIf config.devenvs.nix.tests.enable ''nix build'';

    packages = [
      pkgs.nil
    ];
  };
}
