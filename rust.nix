{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    rust.enable = lib.mkEnableOption "enable rust devenv";
  };

  config = lib.mkIf config.rust.enable {
    languages.rust.enable = true;

    git-hooks.hooks = {
      rustfmt.enable = true;
      taplo.enable = true;
      markdownlint.enable = true;
      yamlfmt.enable = true;
      clippy.enable = true;
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
        entry = "${pkgs.cargo-audit}/bin/cargo-audit audit -n -d ${inputs.devenvs.inputs.advisory-db} -D warnings -D unmaintained -D unsound -D yanked";
        files = "\\.rs$";
        pass_filenames = false;
      };
    };

    packages = [
      #voir la taille des grosses deps
      pkgs.cargo-bloat
      #gerer les deps depuis le cli
      pkgs.cargo-edit
      #auto compile
      pkgs.cargo-watch
    ];

    env = {
      RUST_BACKTRACE = "1";
    };

    scripts = {
      docs.exec = "cargo doc";
      update.exec = "cargo update -v --recursive";

      coverage.exec = "${pkgs.cargo-tarpaulin}/bin/cargo-tarpaulin --skip-clean --out Html";
    };

    enterTest = ''
      ${pkgs.cargo-nextest}/bin/cargo-nextest nextest run
      cargo test --doc
    '';
  };
}
