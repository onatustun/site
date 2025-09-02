{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = {
    config,
    inputs',
    ...
  }: {
    formatter = config.treefmt.build.wrapper;

    treefmt = {
      projectRootFile = "flake.nix";
      enableDefaultExcludes = true;

      settings.global.excludes = [
        "*.envrc"
        "flake.lock"
      ];

      programs = {
        alejandra = {
          enable = true;
          package = inputs'.alejandra.packages.default;
        };

        deadnix = {
          enable = true;
          package = inputs'.deadnix.packages.default;
        };

        prettier.enable = true;
      };
    };
  };
}
