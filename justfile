# Use `just <recipe>` to run a recipe
# https://just.systems/man/en/

# By default, run the `--list` command
default:
    @just --list

# Aliases

alias fmt := format

# Format all files using pre-commit
[group('linter')]
format args='':
    pre-commit run --all-files {{ args }}

# Add git commit hashes to the .git-blame-ignore-revs file
[group('linter')]
add-git-blame-ignore-revs:
    git log --pretty=format:"%H" --grep="^lint" >> .git-blame-ignore-revs
    sort .git-blame-ignore-revs | uniq > .git-blame-ignore-revs.tmp
    mv .git-blame-ignore-revs.tmp .git-blame-ignore-revs
