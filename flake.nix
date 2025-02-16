{
  description = "my devenvs modules for my dev setup";

  inputs = {
    advisory-db = {
      url = "github:rustsec/advisory-db";
      flake = false;
    };
  };

  outputs =
    { self, ... }:
    {
      devenvModules = {
        devenvs = {
          default = import ./default.nix;
          c = import ./c.nix;
          go = import ./go.nix;
          nix = import ./nix.nix;
          python = import ./python.nix;
          rust = import ./rust.nix;
          ts = import ./typescript.nix;
        };
        inherit (self.devenvModules.devenvs) default;
      };
    };
}
