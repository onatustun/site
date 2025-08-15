{
  lib,
  inputs,
  ...
}: let
  inherit (lib) cleanSource;
in {
  perSystem = {pkgs, ...}: let
    inherit (pkgs.stdenv) mkDerivation;
  in {
    packages.default = mkDerivation {
      pname = "site";
      version = "0.1.0";
      src = cleanSource inputs.self;
      doCheck = true;
      dontInstall = true;

      nativeBuildInputs = with pkgs; [
        tailwindcss
        zola
      ];

      buildPhase = ''
        runHook preBuild

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
  };
}
