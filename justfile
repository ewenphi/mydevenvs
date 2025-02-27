#this justfile is generated

# print the just commands
default:
    just --list

alias p := pre-commit-all

# launch all the pre-commit hooks on all the files
pre-commit-all:
    pre-commit run --all-files

alias d := docs

# build the docs
docs:
    mkdocs build

alias a := all

# launch all the steps
all: docs pre-commit-all

alias w := watch

# launch all the steps (can be very intense on cpu)
watch:
    watchexec just   docs pre-commit-all
