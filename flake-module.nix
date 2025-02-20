localFlake:
{ ... }:
{
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
        devenvs.tools.mkdocs.package = lib.mkIf (config.documentation.mkdocs-root != null) (
          lib.mkDefault config.packages.documentation
        );
      };

    };
  imports = [
    localFlake.inputs.devenv.flakeModule
    localFlake.inputs.mkdocs-flake.flakeModule
  ];

}
