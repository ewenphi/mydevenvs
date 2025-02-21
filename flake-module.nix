_localFlake: _: {
  perSystem = _: {
    devenv.shells.default = {
      imports = [ ./default.nix ];
    };
  };
}
