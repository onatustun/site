{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.default = let
      inherit (pkgs.stdenv) mkDerivation;
      inherit (lib) cleanSource;
    in
      mkDerivation {
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

          typst compile ../src/cv.typ ../static/cv.pdf
          tailwindcss -i ../src/input.css -o ../static/output.css --minify
          zola build --output-dir $out --force

          runHook postBuild
        '';

        checkPhase = ''
          runHook preCheck

          zola check

          runHook postCheck
        '';
      };
  };
}
