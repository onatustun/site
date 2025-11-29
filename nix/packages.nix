{
  self,
  lib,
  inputs,
  ...
}: let
  version = "${
    if self ? rev
    then lib.strings.substring 0 8 self.rev
    else "dirty"
  }-flake";

  zolaConfig = lib.trivial.importTOML ../config.toml;
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
        pname = "site";
        inherit version;
        src = pkgs.gitignoreSource ./..;
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
