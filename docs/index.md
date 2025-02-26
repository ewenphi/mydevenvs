This is only a personal extension of [Devenv](https://devenv.sh){:target="\_blank"} for my projects but you can use it.

See the great [Devenv docs](https://devenv.sh/getting-started/){:target="\_blank"} and the [Reference](https://devenv.sh/reference/options/){:target="\_blank"} for devenv usage.

- This is a combinations of devenvs options for go, c, rust, typescript and nix.

- There is features of devenv that are only available with the devenv software.

## Usage with flake-parts

You can bootrap a project with this command :

###

    nix flake init -t github:yvaniak/devenvs

###

Or add the inputs and import the modules in your flake with flake-parts.

###

```nix title="templates/flake.nix"
--8<-- "templates/flake.nix"
```

###

See [devenv flake-parts integration](https://devenv.sh/guides/using-with-flake-parts/){:target="\_blank"} for more details on the flake-parts module.

## Usage with flakes without flake-parts

I don't use it anymore, I use flake-parts now, but open an issue if you want me to add it.

See [devenv flakes integration](https://devenv.sh/guides/using-with-flakes/){:target="\_blank"} for more details on the flakes integration.

## Usage without flakes with the devenv software

This uses the devenv software.

- If you don't already have devenv installed or with no project configured, see [getting started](https://devenv.sh/getting-started/#installation){:target="\_blank"} from devenv.

You must add an input in the devenv.yaml

###

```nix title="devenv.yaml"
inputs:
  nixpkgs: #alredy defined nixpkgs
    url: github:cachix/devenv-nixpkgs/rolling
  devenvs:
    url: github:yvaniak/devenvs
```

And imports the extension in devenv.nix, you can then use the options of the extension

###

```nix title="devenv.nix"
imports = [ inputs.devenvs.devenvModule ];
devenvs.typescript = {
  enable = true;
  prettier.enable = true;
};
```
