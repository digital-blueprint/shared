{
  lib,
  pkgs,
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
      # For npm >= 11 you need to use nodejs_25
      package = mkDefault pkgs.nodejs_25;
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
