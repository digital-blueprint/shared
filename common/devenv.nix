{
  pkgs,
  lib,
  ...
}:

let
  prettier = pkgs.callPackage ../_pkgs/prettier/package.nix { };
in
{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    zellij # smart terminal workspace
    lazygit # git terminal
    just # task runner
  ];

  files.".shared/common.just".text = builtins.readFile ./justfile;

  enterShell = ''
    removed_legacy_hooks=0

    for legacy_hook in .git/hooks/*.legacy; do
      if [ -e "$legacy_hook" ]; then
        rm -f "$legacy_hook"
        removed_legacy_hooks=1
        echo "Removed legacy git hook: $legacy_hook"
      fi
    done

    if [ "$removed_legacy_hooks" -eq 1 ]; then
      echo "Removed legacy git hook backups from .git/hooks."
    fi
  '';

  # https://devenv.sh/git-hooks/
  git-hooks = {
    # Let's try prek, for faster running and maybe preventing issues with i18next
    package = pkgs.prek;

    hooks = {
      prettier = {
        enable = lib.mkDefault true;
        package = prettier;
        files = "\\.(js|json|md|yaml|yml)$";
      };

      shfmt.enable = true;
      nixfmt.enable = true;
      statix.enable = true;
      taplo.enable = true;

      # https://jorisroovers.com/gitlint/latest/
      gitlint = {
        enable = true;
        # Ignore empty body and allow titles up to 100 characters
        # Using args didn't work, because of https://github.com/cachix/git-hooks.nix/issues/641
        # If we need more config we could also pull in a shared config file and set it with "-C"
        entry = "${pkgs.gitlint}/bin/gitlint -c general.ignore=B6 -c title-max-length.line-length=100 --staged --msg-filename";
      };

      # https://devenv.sh/reference/options/#git-hookshooksdeadnix
      # https://github.com/astro/deadnix
      deadnix = {
        enable = true;
        settings = {
          edit = true; # Allow to edit the file if it is not formatted
        };
      };

      # Custom pre-commit hook to format justfile
      just = {
        enable = true;
        name = "just";
        entry = "${pkgs.just}/bin/just --fmt --unstable";
        language = "system";
        pass_filenames = false;
        stages = [ "pre-commit" ];
        files = "(^|/)(justfile|Justfile)$";
      };
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
