{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages = let
      inherit (pkgs.stdenv) mkDerivation;
      inherit (lib) cleanSource;
    in {
      default = mkDerivation {
        pname = "site";
        version = "0.1.0";
        src = cleanSource inputs.self;
        doCheck = true;
        dontInstall = true;

        nativeBuildInputs = with pkgs; [
          tailwindcss
          typst
          zola
        ];

        buildPhase = ''
          runHook preBuild

          typst compile "$PWD/src/cv.typ" "$PWD/static/cv.pdf"
          tailwindcss -i "$PWD/src/input.css" -o "$PWD/static/output.css" --minify
          zola build --output-dir $out --force

          runHook postBuild
        '';

        checkPhase = ''
          runHook preCheck

          zola check

          runHook postCheck
        '';
      };

      cv = mkDerivation {
        pname = "cv";
        version = "0.1.0";
        src = cleanSource inputs.self;
        dontInstall = true;
        nativeBuildInputs = [pkgs.typst];

        buildPhase = ''
          mkdir -p $out
          typst compile "$PWD/src/cv.typ" "$PWD/static/cv.pdf"
        '';
      };
    };
  };
}
