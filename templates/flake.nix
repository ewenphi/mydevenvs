{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenvs.url = "github:yvaniak/devenvs"; # Get the input
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        #other imports
        inputs.devenvs.flakeModule # Import the module and the devenv module
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem = _: {
        #define a devenv shell defined by the flake-parts module
        devenv.shells.default = {
          devenvs = {
            # Change the options
            go.enable = true;
            go.tests.enable = true;
            nix = {
              enable = true;
              flake.enable = true;
              tests.enable = true;
            };
          };

          #Change the regular devenv options
          enterShell = ''
            echo "shell for example project"
          '';
        };
      };
      flake = {
      };
    };
}
