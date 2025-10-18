{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];

  perSystem = {inputs', ...}: {
    pre-commit = {
      check.enable = true;

      settings = {
        package = inputs'.pre-commit-hooks.packages.default;

        excludes = [
          "\\.envrc$"
          "flake\\.lock$"
        ];

        hooks = {
          flake-checker = {
            enable = true;
            package = inputs'.flake-checker.packages.default;
          };

          treefmt.enable = true;
        };
      };
    };
  };
}
