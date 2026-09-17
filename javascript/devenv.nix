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
      oxlint = {
        enable = mkDefault true;

        # Prevents Oxlint from throwing an error if it wants to pick up changes in the vendor, dist or test folder
        args = [ "--no-error-on-unmatched-pattern" ];
      };
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
