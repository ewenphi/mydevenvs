{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    nix = {
      enable = lib.mkEnableOption "enable nix devenv";
      flake.enable = lib.mkEnableOption "enable flake";
      tests.enable = lib.mkEnableOption "nix build in test";
    };
  };

  config = lib.mkIf config.nix.enable {
    languages.nix.enable = true;

    git-hooks.hooks =
      {
        nixfmt-rfc-style.enable = true;
        statix.enable = true;
        deadnix.enable = true;
        commitizen.enable = true;
      }
      // lib.attrsets.optionalAttrs config.nix.flake.enable {
        flake-checker.enable = true;
      };

    common.tests = lib.mkIf config.nix.tests.enable ''nix build'';

    packages = [
      pkgs.nil
    ];
  };
}
