{
  perSystem = {
    self',
    pkgs,
    config,
    ...
  }: {
    devShells = {
      default = self'.devShells.site;

      site = pkgs.mkShell {
        name = "site-dev";
        shellHook = config.pre-commit.installationScript;

        inputsFrom = [
          config.pre-commit.devShell
          config.treefmt.build.devShell
          self'.packages.site
        ];
      };
    };
  };
}
