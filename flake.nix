{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

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
