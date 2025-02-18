{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    nix.enable = lib.mkEnableOption "enable nix devenv";
    nix.flake.enable = lib.mkEnableOption "enable nix build in test";
  };

  config = lib.mkIf config.nix.enable {
    languages.nix.enable = true;

    git-hooks.hooks = {
      nixfmt-rfc-style.enable = true;
      statix.enable = true;
      deadnix.enable = true;
      commitizen.enable = true;
    };

    config.common.tests = lib.mkIf config.nix.flake.enable ''nix build'';

    packages = [
      pkgs.nil
    ];
  };
}
