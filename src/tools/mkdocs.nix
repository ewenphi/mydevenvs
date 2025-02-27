{
  lib,
  config,
  ...
}:
{
  options = {
    mydevenvs.tools.mkdocs = {
      enable = lib.mkEnableOption "enable the mkdocs hook";
    };
  };

  config = lib.mkIf config.mydevenvs.tools.mkdocs.enable {
    git-hooks.hooks = lib.mkIf config.mydevenvs.global.hooks.enable {
      mkdocs-linkcheck.enable = true;
    };

    mydevenvs.tools.just.just-doc = "  mkdocs build";
  };
}
