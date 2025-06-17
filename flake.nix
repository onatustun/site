{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      perSystem = {
        lib,
        pkgs,
        ...
      }: {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            gnumake
            nil
            nodejs
            tailwindcss
            tailwindcss-language-server
            tinymist
            typescript-language-server
            typst
            typstyle
            vscode-langservers-extracted
            zola
          ];
        };

        packages = {
          default = pkgs.stdenv.mkDerivation {
            pname = "site";
            version = "0.1.0";
            src = lib.cleanSource ./.;
            doCheck = true;
            dontInstall = true;

            nativeBuildInputs = with pkgs; [
              nodejs
              tailwindcss
              typst
              zola
            ];

            buildPhase = ''
              runHook preBuild

              typst compile ./cv.typ ./static/cv.pdf
              tailwindcss -i ./input.css -o ./static/output.css --minify
              zola build --output-dir $out --force

              runHook postBuild
            '';

            checkPhase = ''
              runHook preCheck

              zola check

              runHook postCheck
            '';

            meta = with lib; {
              description = "personal website";
              homepage = "https://ust.sh";
              license = licenses.mit;
              platforms = platforms.unix;
            };
          };

          cv = pkgs.stdenv.mkDerivation {
            pname = "cv";
            version = "0.1.0";
            src = lib.cleanSource ./.;

            nativeBuildInputs = with pkgs; [
              typst
            ];

            buildPhase = ''
              mkdir -p $out
              typst compile ./cv.typ $out/cv.pdf
            '';

            dontInstall = true;
          };
        };

        apps = {
          dev = {
            type = "app";
            program = "${pkgs.writeShellScript "dev" ''
              zola serve -i 0.0.0.0 -u localhost -p 3000 &
              typst watch ./cv.typ ./static/cv.pdf &
              tailwindcss -i ./input.css -o ./static/output.css --watch
            ''}";
          };

          clean = {
            type = "app";
            program = "${pkgs.writeShellScript "clean" ''
              rm -rf public/
              rm -rf static/cv.pdf
              rm -rf static/output.css
              rm -rf target/
            ''}";
          };

          purge = {
            type = "app";
            program = "${pkgs.writeShellScript "purge" ''
              rm -rf node_modules/
              rm -rf public/
              rm -rf static/cv.pdf
              rm -rf static/output.css
              rm -rf target/
            ''}";
          };
        };
      };
    };
}
