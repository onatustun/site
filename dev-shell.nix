{
  perSystem = {
    pkgs,
    inputs',
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "zola typst";
      formatter = inputs'.alejandra.packages.default;
      shellHook = config.pre-commit.installationScript;

      packages = with pkgs;
        [
          prettier
          tailwindcss
          tailwindcss-language-server
          tinymist
          typescript-language-server
          typst
          typstyle
          vscode-langservers-extracted
          zola
        ]
        ++ (with inputs'; [
          alejandra.packages.default
        ]);
    };
  };
}
