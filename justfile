#this justfile is generated

# print the list of availables just commands
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
# run all the steps
all:   docs pre-commit-all 

