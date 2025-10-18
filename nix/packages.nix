{
  lib,
  self,
  inputs,
  ...
}: let
  inherit (lib) importTOML substring const;
  zolaConfig = importTOML ../config.toml;

  versionRev =
    if self ? rev
    then substring 0 8 self.rev
    else "dirty";
in {
  perSystem = {
    self',
    system,
    pkgs,
    inputs',
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
        version = "${versionRev}-flake";
        src = pkgs.gitignoreSource ./..;
        doCheck = true;

        nativeBuildInputs = with pkgs; [
          tailwindcss
          zola
        ];

        buildPhase = ''
          runHook preBuild

          tailwindcss -i "$PWD/src/input.css" -o "$PWD/static/output.css" --minify
          zola build --output-dir public --force

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          cp -r public $out

          runHook postInstall
        '';

        checkPhase = ''
          runHook preCheck

          zola check

          runHook postCheck
        '';

        meta = {
          description = zolaConfig.description;
          homepage = zolaConfig.base_url;
          maintainers = with lib.maintainers; [onatustun];
        };
      };

      deadnix =
        inputs'.deadnix.packages.default.overrideAttrs
        <| const {meta.mainProgram = "deadnix";};
    };
  };
}
