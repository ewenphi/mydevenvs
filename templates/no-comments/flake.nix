{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mydevenvs.url = "github:yvaniak/mydevenvs";
    mydevenvs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.mydevenvs.flakeModule
        inputs.mydevenvs.devenv
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem = _: {
        devenv.shells.default = {
          mydevenvs = {
            go.enable = true;
            nix = {
              enable = true;
              flake.enable = true;
            };
          };

          enterShell = ''
            echo "shell for example project"
          '';
        };
      };
      flake = {
      };
    };
}
