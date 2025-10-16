{
  pkgs,
  lib,
  ...
}:

{
  env = {
    CHROMIUM_BIN = lib.getExe pkgs.chromium;
    FIREFOX_BIN = lib.getExe pkgs.firefox;
  };

  # https://devenv.sh/supported-languages/javascript/
  languages = {
    javascript = {
      enable = true;
      npm.enable = true;
      # i18next-parser is not compatible with Node.js 24
      package = lib.mkDefault pkgs.nodejs_22;
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
    echo "🏁 Using Chromium at ${pkgs.chromium.version} and Firefox at ${pkgs.firefox.version} for karma tests"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks = {
    excludes = [ "vendor" ];
    hooks = {
      # Statix needs an extra ignore for the vendor folder
      statix.settings.ignore = [ "vendor" ];
      eslint.enable = true;

      i18next = {
        enable = true;
        name = "i18next";
        description = "Check translations with i18next-cli";
        # If we try this without --dry-run then the hook hangs with high cpu load
        entry = "npx i18next-cli extract --ci --dry-run";
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
