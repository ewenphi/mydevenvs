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
    packages = lib.mkIf config.devenvs.global.packages.enable [ pkgs.clang ];

    git-hooks.hooks = lib.mkIf config.devenvs.global.hooks.enable {
      clang-format.enable = true;
    };
  };
}
