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

  enterShell = ''
    echo "📦 Node version: $(node --version | head -n 1)"
    echo "🏁 Using Chromium at ${pkgs.chromium.version} and Firefox at ${pkgs.firefox.version} for karma tests"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks = {
    excludes = [ "./vendor" ];
    hooks = {
      eslint.enable = true;
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
