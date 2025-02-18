{
  lib,
  config,
  ...
}:
{
  options = {
    common.tests = lib.mkOption {
      type = lib.types.lines;
      description = "the lines that will be fed to enterTest";
      default = "";
      example = ''nix build'';
    };
  };

  config = {
    enterTest = config.common.tests;
  };
}
