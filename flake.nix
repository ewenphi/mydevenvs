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
      imports = [ ];
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      perSystem = _: {

        default = {
          default = import ./default.nix;
          c = import ./c.nix;
          go = import ./go.nix;
          nix = import ./nix.nix;
          python = import ./python.nix;
          rust = import ./rust.nix;
          ts = import ./typescript.nix;
        };
      };
      flake =
        {
        };
    };
}
