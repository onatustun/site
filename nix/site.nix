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
    lib,
    ...
  }: {
    packages = {
      default = self'.packages.site;

      site = pkgs.stdenv.mkDerivation {
        inherit pname;
        version = "${self.shortRev or self.dirtyShortRev}-${self._type}";

        src = lib.sources.cleanSourceWith {
          src = basePath;
          name = pname + "-source";

          filter = inputs.gitignore.lib.gitignoreFilterWith {
            inherit basePath;

            extraRules = ''
              dev-flake/
              flake.lock
              flake.nix
              .github/
              nix/
              outputs.nix
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
          ${lib.meta.getExe pkgs.tailwindcss} -i "$PWD/src/input.css" -o "$PWD/static/output.css" --minify
          ${lib.meta.getExe pkgs.zola} build --output-dir public --force
        '';

        installPhase = ''
          cp -r public $out
        '';

        checkPhase = ''
          ${lib.meta.getExe pkgs.zola} check
        '';

        meta = {
          inherit (zolaConfig) description;
          homepage = zolaConfig.base_url;
          maintainers = [lib.maintainers.onatustun];
        };
      };
    };
  };

  partitions.dev.module.perSystem = {
    self',
    pkgs,
    lib,
    ...
  }: {
    apps = {
      default = self'.apps.site;

      site = {
        type = "app";
        meta.description = "Development port and file watching";

        program = lib.meta.getExe' (pkgs.writers.writeNu "site" ''
          job spawn { ${lib.meta.getExe pkgs.zola} serve -i 0.0.0.0 -u localhost -p 3000 }
          ${lib.meta.getExe pkgs.tailwindcss} -i src/input.css -o static/output.css --watch
        '') "site";
      };

      clean = {
        type = "app";
        meta.description = "Remove build artifacts";

        program = lib.meta.getExe' (pkgs.writers.writeNu "clean" ''
          rm -rf public static/output.css target
        '') "clean";
      };
    };

    checks = {
      default = self'.checks.site;
      inherit (self'.packages) site;
    };

    make-shells.site.inputsFrom = [self'.packages.site];
  };
}
