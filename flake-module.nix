_localFlake: _: {
  perSystem =
    {
      config,
      lib,
      ...
    }:
    {
      documentation = lib.mkIf config.devenv.shells.default.devenvs.tools.mkdocs.enable {
        mkdocs-root = ./.;
        strict = true;
      };

      devenv.shells.default = {
        imports = [ ./default.nix ];
      };

    };
}
