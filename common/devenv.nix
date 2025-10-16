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
    gitlint.enable = true;

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
