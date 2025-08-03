{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    mydevenvs.rust.enable = lib.mkEnableOption "enable rust devenv";
  };

  config = lib.mkIf config.mydevenvs.rust.enable {
    languages.rust.enable = lib.mkIf config.mydevenvs.global.languages.enable true;

    git-hooks.hooks = lib.mkIf config.mydevenvs.global.hooks.enable {
      rustfmt.enable = true;
      taplo.enable = true;
      markdownlint.enable = true;
      yamlfmt.enable = true;
      clippy.enable = true;
      clippy.settings.denyWarnings = true;
      cargo-check.enable = true;
      cargo-deny = {
        enable = true;
        name = "cargo-deny";
        entry = "${pkgs.cargo-deny}/bin/cargo-deny check bans licenses sources";
        files = "\\.rs$";
        pass_filenames = false;
      };
      cargo-machete = {
        enable = true;
        name = "cargo-machete";
        entry = "${pkgs.cargo-machete}/bin/cargo-machete";
        files = "\\.rs$";
        pass_filenames = false;
      };
      cargo-audit = {
        enable = true;
        name = "cargo-audit";
        entry = "${pkgs.cargo-audit}/bin/cargo-audit audit -n -d ${inputs.mydevenvs.inputs.advisory-db} -D unsound -D yanked"; # TODO: maybe essayer de mettre db dans une option pour pas rely on inputs
        files = "\\.rs$";
        pass_filenames = false;
      };
    };

    packages = lib.mkIf config.mydevenvs.global.packages.enable [
      #voir la taille des grosses deps
      pkgs.cargo-bloat
      #gerer les deps depuis le cli
      pkgs.cargo-edit
      #auto compile
      pkgs.cargo-watch

      pkgs.cargo-nextest
      pkgs.cargo-outdated
    ];

    env = lib.mkIf config.mydevenvs.global.env.enable {
      RUST_BACKTRACE = "1";
    };

    mydevenvs = {
      tools = {
        just = {
          just-doc = "  cargo doc";

          just-test = lib.mkIf config.mydevenvs.global.enterTest.enable "  cargo nextest run\n  cargo test --doc";
          just-build = lib.mkIf config.mydevenvs.global.scripts.enable "  cargo build";
          just-run = lib.mkIf config.mydevenvs.global.scripts.enable "  cargo run";
          just-build-release = lib.mkIf config.mydevenvs.global.scripts.enable "  cargo build --release";
          just-upgrade-check = lib.mkIf config.mydevenvs.global.scripts.enable "  cargo outdated --exit-code 10";
          just-upgrade = lib.mkIf config.mydevenvs.global.scripts.enable "  cargo upgrade --recursive";
        };
      };
    };
  };
}
