{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mydevenvs.url = "github:yvaniak/mydevenvs"; # Get the input
    mydevenvs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        #other imports
        inputs.mydevenvs.flakeModule # Import the module and the devenv module
        inputs.mydevenvs.devenv
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
          mydevenvs = {
            # Change the options
            go.enable = true;
            nix = {
              enable = true;
              flake.enable = true;
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
