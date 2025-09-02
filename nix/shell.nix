{
  perSystem = {
    pkgs,
    inputs',
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "zola";
      shellHook = config.pre-commit.installationScript;

      packages = with pkgs;
        [
          prettier
          tailwindcss
          tailwindcss-language-server
          typescript-language-server
          vscode-langservers-extracted
          yaml-language-server
          zola
        ]
        ++ (with inputs'; [
          alejandra.packages.default
          deadnix.packages.default
        ]);
    };
  };
}
