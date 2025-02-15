{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    nix.enable = lib.mkEnableOption "enable nix devenv";
  };

  config = lib.mkIf config.nix.enable {
    languages.nix.enable = true;

    git-hooks.hooks = {
      nixfmt-rfc-style.enable = true;
      statix.enable = true;
      deadnix.enable = true;
      commitizen.enable = true;
    };

    packages = [
      pkgs.nil
    ];
  };
}
