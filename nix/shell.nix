{lib, ...}: let
  inherit (lib) concatLists;
in {
  perSystem = {
    self',
    pkgs,
    config,
    inputs',
    ...
  }: {
    devShells = {
      default = self'.devShells.site;

      site = pkgs.mkShell {
        name = "site-dev";
        shellHook = config.pre-commit.installationScript;

        inputsFrom = concatLists [
          (with config; [
            flake-root.devShell
            pre-commit.devShell
            treefmt.build.devShell
          ])

          (with inputs'; [
            deadnix.devShells
            flake-checker.devShells
          ])

          [self'.packages.site]
        ];

        packages = concatLists [
          (with pkgs; [
            prettier
            tailwindcss
            tailwindcss-language-server
            typescript-language-server
            vscode-langservers-extracted
            yaml-language-server
            zola
          ])

          (with inputs'; [
            alejandra.packages.default
            flake-checker.packages.default
          ])

          [config.packages.deadnix]
        ];
      };
    };
  };
}
