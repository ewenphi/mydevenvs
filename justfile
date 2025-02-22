#this justfile is generated

list:
  just --list







tests:
  pre-commit run --all-files

docs:
  mkdocs build

all:  tests docs

