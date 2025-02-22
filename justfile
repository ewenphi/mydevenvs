#this justfile is generated

default:
  just --list










pre-commit-all:
  pre-commit run --all-files


docs:
  mkdocs build

all:   docs pre-commit-all

