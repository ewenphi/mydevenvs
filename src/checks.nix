{
  config,
  ...
}:
let
  cfg = config.devenv.shells.default;
in
{
  config.checks = {
    ${if cfg.mydevenvs.docs.check.enable then "docs" else null} = cfg.mydevenvs.docs.check.package;
    ${if cfg.mydevenvs.nix.check.enable then "default-package" else null} =
      cfg.mydevenvs.nix.check.package;
  };
}
