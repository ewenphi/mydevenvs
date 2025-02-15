{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = _: {
    homeManagerModules = {
      devenvs = {
        c = import ./c.nix;
      };
    };
  };
}
