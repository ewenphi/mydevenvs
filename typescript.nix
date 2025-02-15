{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    ts.enable = lib.mkEnableOption "enable ts devenv";
    ts.prettier.enable = lib.mkEnableOption "enable prettier";
  };

  config = lib.mkIf config.ts.enable {
    enterTest = ''
      jest
    '';

    languages = {
      javascript = {
        enable = true;
        npm.enable = true;
        npm.install.enable = true;
        package = pkgs.nodejs_latest;
      };
      typescript.enable = true;
    };

    scripts = {
      tests.exec = config.enterTest;
    };

    git-hooks.hooks =
      {
        eslint.enable = true;
        biome.enable = true;
      }
      // lib.mkIf config.ts.prettier.enable {
        prettier.enable = true;
      };
  };
}
