# Use `just <recipe>` to run a recipe
# https://just.systems/man/en/

import "common/justfile"

# By default, run the `--list` command
default:
    @just --list

push-pkgs:
    devenv tasks run cachix:push:_pkgs
