{
  lib,
  config,
  ...
}:
{
  options = {
    devenvs.tools.mkdocs.enable = lib.mkEnableOption "enable the mkdocs hook";
  };

  config = lib.mkIf config.devenvs.tools.mkdocs.enable {
    git-hooks.hooks = lib.mkIf config.devenvs.global.hooks.enable {
      mkdocs-linkcheck.enable = true;
    };
  };
}
