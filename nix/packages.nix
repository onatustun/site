{
  lib,
  self,
  inputs,
  ...
}: let
  zolaConfig = lib.trivial.importTOML ../config.toml;
  basePath = ./..;
  pname = "site";
in {
  perSystem = {
    self',
    pkgs,
    ...
  }: {
    packages = {
      default = self'.packages.site;

      site = pkgs.stdenv.mkDerivation {
        inherit pname;
        version = "${self.shortRev or "dirty"}-${self._type}";

        src = lib.sources.cleanSourceWith {
          src = basePath;
          name = pname + "-source";

          filter = inputs.gitignore.lib.gitignoreFilterWith {
            inherit basePath;

            extraRules = ''
              flake.lock
              flake.nix
              .github/
              nix/
              result/
            '';
          };
        };

        doCheck = true;

        nativeBuildInputs = [
          pkgs.coreutils
          pkgs.tailwindcss
          pkgs.zola
        ];

        buildPhase = ''
          runHook preBuild

          ${lib.meta.getExe pkgs.tailwindcss} -i "$PWD/src/input.css" -o "$PWD/static/output.css" --minify
          ${lib.meta.getExe pkgs.zola} build --output-dir public --force

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          ${lib.meta.getExe' pkgs.coreutils "cp"} -r public $out

          runHook postInstall
        '';

        checkPhase = ''
          runHook preCheck

          ${lib.meta.getExe pkgs.zola} check

          runHook postCheck
        '';

        meta = {
          inherit (zolaConfig) description;
          homepage = zolaConfig.base_url;
          maintainers = [lib.maintainers.onatustun];
        };
      };
    };
  };
}
