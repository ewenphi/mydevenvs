{ config, lib, ... }:
{
  options = {
    mydevenvs.python.enable = lib.mkEnableOption "enable python devenv";
  };

  config = lib.mkIf config.mydevenvs.python.enable {
    languages.python.enable = lib.mkIf config.mydevenvs.global.languages.enable true;

    git-hooks.hooks = lib.mkIf config.mydevenvs.global.hooks.enable {
      ruff.enable = true;
      pylint.enable = true;
      black.enable = true;
      isort.enable = true;
      autoflake.enable = true;
      pyupgrade.enable = true;
    };
  };
}
