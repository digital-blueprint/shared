_:

{
  # https://devenv.sh/supported-languages/php/
  languages.php.enable = true;

  enterShell = ''
    echo "🐘 PHP version: $(php --version | head -n 1)"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks = {
    hooks = {
      php-cs-fixer = {
        enable = true;
        args = [
          "--config"
          "./.php-cs-fixer.dist.php"
        ];
        excludes = [ "config/bundles.php" ];
        # Don't spam so many messages
        require_serial = true;
      };
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
