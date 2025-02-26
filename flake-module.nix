_localFlake: _: {
  perSystem =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.devenv.shells.default;
    in
    {
      devenv.modules = [
        ./default.nix
      ];

      checks =
        { }
        // lib.optionalAttrs cfg.devenvs.docs.check.enable {
          docs = cfg.devenvs.docs.check.package;
        }
        // lib.optionalAttrs cfg.devenvs.nix.check.enable {
          default-package = cfg.devenvs.nix.check.package;
        }
        // lib.optionalAttrs cfg.devenvs.tools.git-hooks.enable {
          git-hooks = cfg.git-hooks.run;
        };
    };
}
