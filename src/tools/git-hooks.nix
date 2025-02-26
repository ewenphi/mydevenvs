{
  lib,
  ...
}:
{
  options = {
    devenvs.tools.git-hooks = {
      enable = lib.mkEnableOption "enable the git hooks check";
    };
  };
}
