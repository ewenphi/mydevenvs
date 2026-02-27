{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    mydevenvs.tools.just = {
      enable = lib.mkEnableOption "enable the just-generate script";
      pre-commit.enable = lib.mkEnableOption "enable the launch of pre-commit on all files in just test";
      check.enable = lib.mkEnableOption "enable the launch nix flake check (test the presence of nix before)";
      just-content = lib.mkOption {
        default = "";
        description = "internal to contain all the justfile";
        type = lib.types.lines;
      };
      just-build = lib.mkOption {
        default = "";
        type = lib.types.lines;
        example = "cargo build";
        description = "a command to build the software, that is added to the justfile";
      };
      just-run = lib.mkOption {
        default = "";
        type = lib.types.lines;
        example = "cargo run";
        description = "a command to run the software, that is added to the justfile";
      };
      just-doc = lib.mkOption {
        default = "";
        type = lib.types.lines;
        example = "cargo doc";
        description = "a command to build the docs, that is added to the justfile";
      };
      just-test = lib.mkOption {
        default = "";
        type = lib.types.lines;
        example = "cargo test";
        description = "a command that launches the tests, that is addad to the justfile";
      };
      just-build-release = lib.mkOption {
        default = "";
        type = lib.types.lines;
        example = "npm run build";
        description = "a command that build the software in release mode, that is addad to the justfile";
      };
      just-upgrade = lib.mkOption {
        default = "";
        type = lib.types.lines;
        example = "npm upgrade";
        description = "a command that upgrade the software dependencies";
      };
      just-upgrade-check = lib.mkOption {
        default = "";
        type = lib.types.lines;
        example = "npm outdated";
        description = "a command that check if the software dependencies are up to date";
      };

    };
  };

  config = lib.mkIf config.mydevenvs.tools.just.enable {
    packages = [
      pkgs.just
      pkgs.watchexec
      pkgs.pre-commit
    ];
    enterShell = "alias j=just";

    scripts = lib.mkIf config.mydevenvs.global.scripts.enable {
      just-generate.exec = ''
        echo "${config.mydevenvs.tools.just.just-content}" > justfile
        just --fmt --unstable
      '';
    };

    mydevenvs.tools.just.just-content = ''
      #this justfile is generated

      # print the just commands
      default:
        just --list

      ${
        if config.mydevenvs.tools.just.just-build != "" then
          "alias b := build\n# build the software\nbuild:"
        else
          ""
      }
      ${config.mydevenvs.tools.just.just-build}

      ${
        if (config.mydevenvs.tools.just.just-run != "") then
          "alias r := run\n# run the software\nrun:${
            if config.mydevenvs.tools.just.just-build != "" then " build" else ""
          }"
        else
          ""
      }
      ${config.mydevenvs.tools.just.just-run}

      ${
        if (config.mydevenvs.tools.just.just-test != "") then
          "alias t := tests\n# launch all the tests\ntests:${
            if config.mydevenvs.tools.just.just-build != "" then " build" else ""
          }"
        else
          ""
      }
      ${config.mydevenvs.tools.just.just-test}

      ${
        if config.mydevenvs.tools.just.pre-commit.enable then
          ''
            alias pa := pre-commit-all
            # launch all the pre-commit hooks on all the files
            pre-commit-all:
              pre-commit run --all-files

            alias p := pre-commit
            # launch all the pre-commit hooks
            pre-commit:
              pre-commit run
          ''
        else
          ""
      }

      ${
        if config.mydevenvs.tools.just.just-doc != "" then
          "alias d := docs\n# build the docs\ndocs:"
        else
          ""
      }
      ${config.mydevenvs.tools.just.just-doc}

      ${
        if config.mydevenvs.tools.just.just-build-release != "" then
          "alias br := build-release\n# build the software in release mode\nbuild-release:"
        else
          ""
      }
      ${config.mydevenvs.tools.just.just-build-release}

      ${
        if config.mydevenvs.tools.just.check.enable then
          ''
            alias nc := nix-checks
            # launch all the checks in a flake if present and nix is available
            nix-checks:
              if "nix --version"; then \
                nix flake check --no-pure-eval --extra-experimental-features flakes --extra-experimental-features nix-command;\
              else \
                echo "nix is not available, so the nix checks are skipped"; \
              fi
          ''
        else
          ""
      }

      ${
        if config.mydevenvs.tools.just.just-upgrade-check != "" then
          ''
            alias uc := upgrade-check
            # check if the dependencies need updates
            upgrade-check:''
        else
          ""
      }
      ${config.mydevenvs.tools.just.just-upgrade-check}

      ${
        if config.mydevenvs.tools.just.just-upgrade != "" then
          ''
            alias u := upgrade
            # upgrade the dependencies
            upgrade:''
        else
          ""
      }
      ${config.mydevenvs.tools.just.just-upgrade}

      alias a := all
      # launch all the steps that involves checks
      all: ${if config.mydevenvs.tools.just.pre-commit.enable then "pre-commit-all" else ""} ${
        if config.mydevenvs.tools.just.just-build != "" then "build" else ""
      } ${if config.mydevenvs.tools.just.just-test != "" then "tests" else ""} ${
        if config.mydevenvs.tools.just.just-doc != "" then "docs" else ""
      }  ${if config.mydevenvs.tools.just.just-build-release != "" then "build-release" else ""} ${
        if config.mydevenvs.tools.just.check.enable then "nix-checks" else ""
      }


      alias w := watch
      # launch all the steps (can be very intense on cpu)
      watch:
        watchexec just ${if config.mydevenvs.tools.just.just-build != "" then "build" else ""} ${
          if config.mydevenvs.tools.just.just-test != "" then "tests" else ""
        } ${if config.mydevenvs.tools.just.just-doc != "" then "docs" else ""} ${
          if config.mydevenvs.tools.just.pre-commit.enable then "pre-commit-all" else ""
        }
    '';
  };
}
