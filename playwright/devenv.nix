{
  pkgs,
  lib,
  ...
}:

let
  inherit (builtins.fromJSON (builtins.readFile "${pkgs.playwright-driver}/browsers.json")) browsers;
  chromium-rev = (builtins.head (builtins.filter (x: x.name == "chromium") browsers)).revision;
  firefox-rev = (builtins.head (builtins.filter (x: x.name == "firefox") browsers)).revision;
in
{
  # https://devenv.sh/basics/
  env = {
    # Use the Playwright browsers installed by nix package for unit tests
    CHROMIUM_BIN = lib.mkDefault "${pkgs.playwright.browsers}/chromium-${chromium-rev}/chrome-linux/chrome";
    FIREFOX_BIN = lib.mkDefault "${pkgs.playwright.browsers}/firefox-${firefox-rev}/firefox/firefox";
  };

  # https://devenv.sh/supported-languages/javascript/
  languages = {
    javascript = {
      enable = lib.mkDefault true;
      npm.enable = lib.mkDefault true;
    };
  };

  enterShell = ''
    echo "🏁 Using Chromium at ${pkgs.chromium.version} and Firefox at ${pkgs.firefox.version} from Playwright for unit tests"
  '';

  # See full reference at https://devenv.sh/reference/options/
}
