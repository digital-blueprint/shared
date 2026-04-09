{
  pkgs,
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
      # Node.js 24 for npm minimumReleaseAge
      # But for npm >= 11 you need to use nodejs_25, otherwise you get "npm ERR! code EBADENGINE Unsupported engine"
      package = mkDefault pkgs.nodejs_25;
    };
  };

  # https://devenv.sh/packages/
  packages = with pkgs; [
    fzf # fuzzy finder, for "just watch"
  ];

  # Shared justfile
  files.".shared/dbp-app.just".text = builtins.readFile ./justfile;

  enterShell = ''
    echo "📦 Node version: $(node --version | head -n 1)"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks = {
    excludes = [ "vendor" ];
    hooks = {
      # Statix needs an extra ignore for the vendor folder
      statix.settings.ignore = [ "vendor" ];
      eslint.enable = mkDefault true;

      i18next = {
        enable = mkDefault true;
        name = "i18next";
        description = "Check translations with i18next-cli";
        # Try "env TERM=dumb" to prevent i18next-cli of being stuck
        entry = "env TERM=dumb npx i18next-cli extract --ci";
        language = "system";
        pass_filenames = false;
        files = "(src/.*\\.js$|translation\\.json$)";
        stages = [ "pre-commit" ];
        require_serial = true;
      };
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
