{
  pkgs,
  lib,
  ...
}:
{
  options = {
    c.enable = lib.mkEnableOption "enable c devenv";
  };

  config = lib.mkIf config.c.enable {
    packages = [ pkgs.clang ];

    git-hooks.hooks = {
      clang-format.enable = true;
    };
  };
}
