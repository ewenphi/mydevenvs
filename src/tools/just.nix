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
    };
  };

  config = lib.mkIf config.mydevenvs.tools.just.enable {
    packages = [ pkgs.just ];

    scripts = lib.mkIf config.mydevenvs.global.scripts.enable {
      just-generate.exec = ''
        echo "${config.mydevenvs.tools.just.just-content}" > justfile
      '';

      all.exec = ''
        nix flake check --no-pure-eval
        just-generate
        just "all"
        pre-commit run --all-files
      '';
    };

    mydevenvs.tools.just.just-content = ''
      #this justfile is generated

      default:
        just --list

      ${if config.mydevenvs.tools.just.just-build != "" then "build:" else ""}
      ${config.mydevenvs.tools.just.just-build}

      ${
        if (config.mydevenvs.tools.just.just-run != "") then
          "run:${if config.mydevenvs.tools.just.just-build != "" then " build" else ""}"
        else
          ""
      }
      ${config.mydevenvs.tools.just.just-run}

      ${
        if (config.mydevenvs.tools.just.just-test != "") then
          "tests:${if config.mydevenvs.tools.just.just-build != "" then " build" else ""}"
        else
          ""
      }
      ${config.mydevenvs.tools.just.just-test}

      ${
        if config.mydevenvs.tools.just.pre-commit.enable then
          ''
            pre-commit-all:
              pre-commit run --all-files
          ''
        else
          ""
      }

      ${if config.mydevenvs.tools.just.just-doc != "" then "docs:" else ""}
      ${config.mydevenvs.tools.just.just-doc}

      ${if config.mydevenvs.tools.just.just-build-release != "" then "build-release:" else ""}
      ${config.mydevenvs.tools.just.just-build-release}

      all: ${if config.mydevenvs.tools.just.just-build != "" then "build" else ""} ${
        if config.mydevenvs.tools.just.just-test != "" then "tests" else ""
      } ${if config.mydevenvs.tools.just.just-doc != "" then "docs" else ""} ${
        if config.mydevenvs.tools.just.pre-commit.enable then "pre-commit-all" else ""
      } ${if config.mydevenvs.tools.just.just-build-release != "" then "build-release" else ""}
    '';
  };
}
