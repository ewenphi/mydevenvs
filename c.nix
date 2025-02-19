{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    devenvs.c.enable = lib.mkEnableOption "enable c devenv";
  };

  config = lib.mkIf config.devenvs.c.enable {
    packages = [ pkgs.clang ];

    git-hooks.hooks = {
      clang-format.enable = true;
    };
  };
}
