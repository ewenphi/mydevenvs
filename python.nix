{ config, lib, ... }:
{
  options = {
    devenvs.python.enable = lib.mkEnableOption "enable python devenv";
  };

  config = lib.mkIf config.devenvs.python.enable {
    languages.python.enable = true;

    git-hooks.hooks = {
      ruff.enable = true;
      pylint.enable = true;
      black.enable = true;
      isort.enable = true;
      autoflake.enable = true;
      pyupgrade.enable = true;
    };
  };
}
