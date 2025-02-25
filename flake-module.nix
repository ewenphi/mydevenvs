_localFlake:
{ config, lib, ... }:
{
  perSystem = _: {
    devenv.modules = [
      ./default.nix
    ];
    #attrset of packages as an option in the module to add the cargo doc
    checks = {
      build-default-package = lib.mkIf (config.packages.default != null) config.packages.default;
    };
  };
}
