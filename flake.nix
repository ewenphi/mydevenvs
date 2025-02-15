{
  description = "my devenvs modules for my dev setup";

  outputs =
    { self, ... }:
    {
      homeManagerModules = {
        devenvs = {
          default = import ./default.nix;
          c = import ./c.nix;
          go = import ./go.nix;
          nix = import ./nix.nix;
          python = import ./python.nix;
          rust = import ./rust.nix;
          ts = import ./typescript.nix;
        };
        inherit (self.homeManagerModules.devenvs) default;
      };
    };
}
