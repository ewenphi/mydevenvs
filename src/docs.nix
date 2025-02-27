{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    mydevenvs.docs = {
      check = {
        enable = lib.mkEnableOption "add the doc package to the checks";
        package = lib.mkPackageOption pkgs "docs" {
          default = null;
          nullable = true;
          example = "config.packages.documentation";
          extraDescription = "A documentation package to add to the tests";
        };
        docs-builder = lib.mkPackageOption pkgs "docs-builder" {
          default = null;
          nullable = true;
          example = "config.packages.documentation.mkdocs-package";
          extraDescription = "A package that is used to build the docs";
        };
      };
    };
  };

  config = lib.mkIf config.mydevenvs.docs.check.enable {
    packages = lib.mkIf (config.mydevenvs.docs.check.docs-builder != null) [
      config.mydevenvs.docs.check.docs-builder
    ];
  };
}
