{ pkgs, ... }:

{
  # Push local project packages to https://dbp-shared.cachix.org.
  # This also adds the cache to `cachix.pull` for this project.
  cachix.push = "dbp-shared";

  tasks."cachix:push:_pkgs" = {
    description = "Build and push local _pkgs packages to dbp-shared Cachix.";
    package = pkgs.bash;
    exec = ''
      packages=(
        _pkgs/i18next-cli
        _pkgs/prettier
      )

      for package in "''${packages[@]}"; do
        store_path=$(nix-build -E "((import <nixpkgs> {}).callPackage (import ./$package/package.nix) { })" --no-out-link --show-trace)
        ${pkgs.cachix}/bin/cachix push dbp-shared "$store_path"
      done
    '';
  };

  enterShell = ''
    echo "🛠️ DBP Shared Dev Shell"
  '';

  # See full reference at https://devenv.sh/reference/options/
}
