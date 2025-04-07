{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    mydevenvs.c = {
      enable = lib.mkEnableOption "enable c devenv";
      meson.enable = lib.mkEnableOption "enable option in just";
      meson.name = lib.mkOption {
        description = "name used in meson.build";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.mydevenvs.c.enable {
    packages = lib.mkIf config.mydevenvs.global.packages.enable [
      pkgs.clang
      (lib.mkIf config.mydevenvs.c.meson.enable pkgs.meson)
      (lib.mkIf config.mydevenvs.c.meson.enable pkgs.ninja)
    ];

    git-hooks.hooks = lib.mkIf config.mydevenvs.global.hooks.enable {
      clang-format.enable = true;
    };

    mydevenvs.tools.just = lib.mkIf config.mydevenvs.c.meson.enable {
      just-test = lib.mkIf config.mydevenvs.global.enterTest.enable "  meson test -C builddir";
      just-build = lib.mkIf config.mydevenvs.global.scripts.enable "  meson compile -C builddir";
      just-run = lib.mkIf config.mydevenvs.global.scripts.enable "  ./builddir/${config.mydevenvs.c.meson.name}";
    };
  };
}
