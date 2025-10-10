{
  pkgs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    just # task runner
  ];

  enterShell = ''
    echo "🛠️ DBP Shared Dev Shell"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    nixfmt-rfc-style.enable = true;
    statix.enable = true;
    taplo.enable = true;

    # https://devenv.sh/reference/options/#git-hookshooksdeadnix
    # https://github.com/astro/deadnix
    deadnix = {
      enable = true;
      settings = {
        edit = true; # Allow to edit the file if it is not formatted
      };
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
