This is only a personal extension of [Devenv](https://devenv.sh){:target="\_blank"} for my projects but you can use it.

See the great [Devenv docs](https://devenv.sh/getting-started/){:target="\_blank"} and the [Reference](https://devenv.sh/reference/options/){:target="\_blank"} for devenv usage.

- This is a combinations of devenvs options for go, c, rust, typescript and nix.

- There is features of devenv that are only available with the devenv software.

## Usage with flake-parts

You can bootrap a project with this command :

###

    nix flake init -t github:yvaniak/devenvs

###

Or add the inputs and import the modules in your flake with flake-parts.

###

    {
      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-parts.url = "github:hercules-ci/flake-parts";
        devenvs.url = "github:yvaniak/devenvs";  #Get the input
      };

      outputs =
        inputs:
        inputs.flake-parts.lib.mkFlake { inherit inputs; } {
        imports = [
          #other imports
          inputs.devenvs.flakeModules.default    #Import the module and
          inputs.devenvs.devenv                  the devenv module
        ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];
        perSystem =
          {
          self',
          config,
          ...
          }:
          {
          #define a devenv shell defined by the flake-parts module
          devenv.shells.default = {
            devenvs = {                          #Change the options
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

###

See [devenv flake-parts integration](https://devenv.sh/guides/using-with-flake-parts/){:target="\_blank"} for more details on the flake-parts module.

## Usage with flakes without flake-parts

I don't use it anymore, I use flake-parts now, but open an issue if you want me to add it.

See [devenv flakes integration](https://devenv.sh/guides/using-with-flakes/){:target="\_blank"} for more details on the flakes integration.

## Usage without flakes with the devenv software

This uses the devenv software.

- If you don't already have devenv installed or with no project configured, see [getting started](https://devenv.sh/getting-started/#installation){:target="\_blank"} from devenv.

You must add an input in the devenv.yaml

###

    inputs:
      nixpkgs: #alredy defined nixpkgs
        url: github:cachix/devenv-nixpkgs/rolling
      devenvs:
        url: github:yvaniak/devenvs

And imports the extension in devenv.nix, you can then use the options of the extension

###

    imports = [ inputs.devenvs.devenvModule ];
    devenvs.typescript = {
      enable = true;
      prettier.enable = true;
    };
