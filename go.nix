{
  lib,
  config,
  ...
}:
{
  options = {
    devenvs.go.enable = lib.mkEnableOption "enable go devenv";
    devenvs.go.tests.enable = lib.mkEnableOption "enable go test";
  };

  config = lib.mkIf config.devenvs.go.enable {
    languages.go.enable = lib.mkIf config.devenvs.global.languages.enable true;

    git-hooks.hooks = lib.mkIf config.devenvs.global.hooks.enable {
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

    enterTest = lib.mkIf config.devenvs.global.enterTest.enable (
      lib.mkIf config.devenvs.go.tests.enable ''
        go test
      ''
    );

    devenvs.tools.just.just-test = lib.mkIf config.devenvs.global.enterTest.enable (
      lib.mkIf config.devenvs.go.tests.enable "  go test"
    );
  };
}
