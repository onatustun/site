{
  self,
  lib,
  inputs,
  ...
}: let
  version = "${self.shortRev or "dirty"}-flake";
  zolaConfig = lib.trivial.importTOML ../config.toml;
  basePath = ./..;
  pname = "site";
in {
  perSystem = {
    system,
    self',
    pkgs,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [inputs.gitignore.overlay];
    };

    packages = {
      default = self'.packages.site;

      site = pkgs.stdenv.mkDerivation {
        inherit pname version;

        src = lib.sources.cleanSourceWith {
          src = basePath;
          name = pname + "-source";

          filter = pkgs.gitignoreFilterWith {
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

          ${lib.meta.getExe' pkgs.coreutils "mkdir"} -p $out
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
