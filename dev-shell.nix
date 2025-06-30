{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "zola typst";
      formatter = pkgs.alejandra;

      packages = with pkgs; [
        alejandra
        gnumake
        nil
        prettier
        tailwindcss
        tailwindcss-language-server
        tinymist
        typescript-language-server
        typst
        typstyle
        vscode-langservers-extracted
        zola
      ];

      shellHook = ''
        ${config.pre-commit.installationScript}
      '';
    };
  };
}
