{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    devenvs.ts = {
      enable = lib.mkEnableOption "enable ts devenv";
      prettier.enable = lib.mkEnableOption "enable prettier hook";
      biome.enable = lib.mkEnableOption "enable biome hook";
      tests.enable = lib.mkEnableOption "enable tests with jest";
      script-lint.enable = lib.mkEnableOption "run npm lint as a hook";
    };
  };

  config = lib.mkIf config.devenvs.ts.enable {
    enterTest = lib.mkIf config.devenvs.global.enterTest.enable (
      lib.mkIf config.devenvs.ts.tests.enable ''
        jest
      ''
    );

    languages = lib.mkIf config.devenvs.global.languages.enable {
      javascript = {
        enable = true;
        npm.enable = true;
        npm.install.enable = true;
        package = pkgs.nodejs_latest;
      };
      typescript.enable = true;
    };

    scripts = lib.mkIf config.devenvs.global.scripts.enable {
      tests.exec = config.enterTest;
    };

    git-hooks.hooks =
      lib.mkIf config.devenvs.global.hooks.enable {
        eslint.enable = true;
      }
      // lib.attrsets.optionalAttrs config.devenvs.ts.biome.enable {
        biome.enable = true;
      }
      // lib.attrsets.optionalAttrs config.devenvs.ts.prettier.enable {
        prettier.enable = true;
      }
      // lib.attrsets.optionalAttrs config.devenvs.ts.script-lint.enable {
        npm-lint = {
          enable = true;
          entry = "npm run lint";
          files = "\\.((js)|(ts))";
          pass_filenames = false;
        };
      };
  };
}
