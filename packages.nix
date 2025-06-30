{
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    packages = {
      default = pkgs.stdenv.mkDerivation {
        pname = "site";
        version = "0.1.0";
        src = lib.cleanSource ./.;
        doCheck = true;
        dontInstall = true;

        nativeBuildInputs = with pkgs; [
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
      };

      cv = pkgs.stdenv.mkDerivation {
        pname = "cv";
        version = "0.1.0";
        src = lib.cleanSource ./.;
        dontInstall = true;
        nativeBuildInputs = [pkgs.typst];

        buildPhase = ''
          mkdir -p $out
          typst compile ./cv.typ $out/cv.pdf
        '';
      };
    };
  };
}
