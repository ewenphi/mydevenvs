{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    mydevenvs.c.enable = lib.mkEnableOption "enable c devenv";
  };

  config = lib.mkIf config.mydevenvs.c.enable {
    packages = lib.mkIf config.mydevenvs.global.packages.enable [ pkgs.clang ];

    git-hooks.hooks = lib.mkIf config.mydevenvs.global.hooks.enable {
      clang-format.enable = true;
    };
  };
}
