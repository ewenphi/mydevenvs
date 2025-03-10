#this justfile is generated

# print the just commands
default:
    just --list

alias pa := pre-commit-all

# launch all the pre-commit hooks on all the files
pre-commit-all:
    pre-commit run --all-files

alias p := pre-commit

# launch all the pre-commit hooks
pre-commit:
    pre-commit run

alias d := docs

# build the docs
docs:
    mkdocs build

alias nc := nix-checks

# launch all the checks in a flake if present and nix is available
nix-checks:
    if nix --version; then     nix flake check --no-pure-eval --extra-experimental-features flakes --extra-experimental-features nix-command;  else     echo nix is not available, so the nix checks are skipped;   fi

alias a := all

# launch all the steps
all: pre-commit-all docs nix-checks

alias w := watch

# launch all the steps (can be very intense on cpu)
watch:
    watchexec just   docs pre-commit-all
