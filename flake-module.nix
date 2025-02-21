_localFlake: _: {
  perSystem =
    {
      config,
      lib,
      ...
    }:
    {
      documentation =
        if (config.documentation != null) then
          lib.mkIf config.devenv.shells.default.devenvs.tools.mkdocs.enable {
            mkdocs-root = ./.;
            strict = true;
          }
        else
          null;

      devenv.shells.default = {
        imports = [ ./default.nix ];
      };

    };
}
