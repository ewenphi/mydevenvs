_localFlake: _: {
  perSystem = _: {
    devenv.modules = [
      ./default.nix
    ];

    imports = [ ./src/checks.nix ];
  };
}
