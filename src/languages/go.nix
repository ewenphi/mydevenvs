{
  lib,
  config,
  ...
}:
{
  options = {
    mydevenvs.go.enable = lib.mkEnableOption "enable go devenv";
  };

  config = lib.mkIf config.mydevenvs.go.enable {
    languages.go.enable = lib.mkIf config.mydevenvs.global.languages.enable true;

    git-hooks.hooks = lib.mkIf config.mydevenvs.global.hooks.enable {
      gofmt.enable = true;
      golangci-lint.enable = true;
      gotest.enable = true;
      govet.enable = true;
      revive.enable = true;
      staticcheck.enable = true;
      govulncheck = {
        enable = true;
        name = "govulncheck";
        entry = "go run golang.org/x/vuln/cmd/govulncheck@latest ./...";
        files = "\\.go$";
        pass_filenames = false;
      };
    };

    mydevenvs = {
      tools = {
        just = {
          just-build = lib.mkIf config.mydevenvs.global.scripts.enable "  go build";
          just-run = lib.mkIf config.mydevenvs.global.scripts.enable "  go run .";
        };
      };
    };
  };
}
