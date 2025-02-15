{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    ts.enable = lib.mkEnableOption "enable ts devenv";
  };

  config = lib.mkIf config.ts.enable {
    enterShell = ''
      echo hello from
    '';

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

    git-hooks.hooks = {
      prettier.enable = true;
      eslint.enable = true;
      biome.enable = true;
    };
  };
}
