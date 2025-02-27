{
  lib,
  pkgs,
  ...
}:
{
  options = {
    mydevenvs.docs = {
      check.enable = lib.mkEnableOption "add the doc package to the checks";
      check.package = lib.mkPackageOption pkgs "docs" {
        default = null;
        nullable = true;
        example = "config.packages.documentation";
        extraDescription = "A documentation package to add to the tests";
      };
    };
  };
}
