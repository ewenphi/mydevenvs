{
  lib,
  config,
  ...
}:
{
  options = {
    go.enable = lib.mkEnableOption "enable go devenv";
    go.tests.enable = lib.mkEnableOption "enable go test";
  };

  config = lib.mkIf config.go.enable {
    languages.go.enable = true;

    git-hooks.hooks = {
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

    enterTest = lib.mkIf config.go.tests.enable ''
      go test
    '';
  };
}
