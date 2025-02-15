{
  description = "my devenvs modules for my dev setup";

  outputs = _: {
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
    };
  };
}
