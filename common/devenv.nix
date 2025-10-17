{
  pkgs,
  lib,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    zellij # smart terminal workspace
    lazygit # git terminal
    just # task runner
  ];

  # https://devenv.sh/tasks/
  tasks = {
    # To remove the old git commit hook
    "cleanup:git-hooks" = {
      exec = ''
        rm -f .git/hooks/pre-commit.legacy
      '';
      before = [ "devenv:enterShell" ];
    };
  };

  files.".shared/common.just".text = builtins.readFile ./justfile;

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    prettier = {
      enable = lib.mkDefault true;
      files = "\\.(js|json|md|yaml|yml)$";
    };

    shfmt.enable = true;
    nixfmt-rfc-style.enable = true;
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

  # See full reference at https://devenv.sh/reference/options/
}
