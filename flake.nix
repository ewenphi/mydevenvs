{
  description = "my devenvs modules for my dev setup";

  inputs = {
    advisory-db = {
      url = "github:rustsec/advisory-db";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.flake-parts.flakeModules.flakeModules ];
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      perSystem =
        _:
        {
        };
      flake = {
        flakeModule = {
          default = import ./default.nix;
        };
      };
    };
}
