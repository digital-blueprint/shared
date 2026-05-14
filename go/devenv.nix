{
  lib,
  ...
}:

{
  # https://devenv.sh/supported-languages/go/
  languages.go.enable = true;

  enterShell = ''
    echo "🐹 Go version: $(go version | head -n 1)"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    gofmt.enable = lib.mkDefault true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
