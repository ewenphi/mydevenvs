_localFlake: _: {
  perSystem = _: {
    devenv.modules = [
      ./default.nix
    ];
  };
}
