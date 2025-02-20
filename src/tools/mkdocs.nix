{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    devenvs.tools.mkdocs = {
      enable = lib.mkEnableOption "enable the mkdocs hook";
      package = lib.mkPackageOption pkgs "mkdocs-docs" {
        default = null;
        nullable = true;
        example = "config.packages.documentation";
        extraDescription = "A mkdocs package produced by the mkdocs-flake module";
      };
    };
  };

  config = lib.mkIf config.devenvs.tools.mkdocs.enable {
    git-hooks.hooks = lib.mkIf config.devenvs.global.hooks.enable {
      mkdocs-linkcheck.enable = true;
    };

    enterTest = lib.mkIf config.devenvs.global.enterTest.enable (
      lib.mkIf (config.devenvs.tools.mkdocs.package != null) "test ${config.devenvs.tools.mkdocs.package}"
    );

  };
}
