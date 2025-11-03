{
  lib,
  ...
}:
let
  inherit (lib)
    mkDefault
    ;
in
{
  # https://devenv.sh/supported-languages/javascript/
  languages = {
    javascript = {
      enable = mkDefault true;
      npm.enable = mkDefault true;
    };
  };

  enterShell = ''
    echo "📦 Node version: $(node --version | head -n 1)"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks = {
    hooks = {
      eslint.enable = mkDefault true;
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
