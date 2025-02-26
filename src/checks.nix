{
  config,
  ...
}:
let
  cfg = config.devenv.shells.default;
in
{
  config.checks = {
    ${if cfg.devenvs.docs.check.enable then "docs" else null} = cfg.devenvs.docs.check.package;
    ${if cfg.devenvs.nix.check.enable then "default-package" else null} = cfg.devenvs.nix.check.package;
    ${if cfg.devenvs.tools.git-hooks.enable then "git-hooks" else null} = cfg.git-hooks.run;
  };
}
