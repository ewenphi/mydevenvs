{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    nix.enable = lib.mkEnableOption "enable nix devenv";
    nix.nix-build.enable = lib.mkEnableOption "enable nix build in test";
  };

  config = lib.mkIf config.nix.enable {
    languages.nix.enable = true;

    git-hooks.hooks = {
      nixfmt-rfc-style.enable = true;
      statix.enable = true;
      deadnix.enable = true;
      commitizen.enable = true;
    };

    enterTest = lib.mkIf config.nix.nix-build.enable (lib.mkDefault ''nix build'');

    packages = [
      pkgs.nil
    ];
  };
}
