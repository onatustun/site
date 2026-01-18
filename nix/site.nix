{self, ...}: {
  perSystem = {
    lib,
    self',
    pkgs,
    ...
  }: let
    root = ./..;
    zolaConfig = lib.trivial.importTOML (root + /config.toml);
  in {
    packages = {
      default = self'.packages.site;

      site = pkgs.stdenv.mkDerivation {
        pname = "site";
        version = "${self.shortRev or self.dirtyShortRev}-${self._type}";

        src = lib.fileset.toSource {
          inherit root;

          fileset =
            lib.fileset.intersection (lib.fileset.gitTracked root)
            (lib.fileset.unions [
              (root + "/config.toml")
              (root + "/content")
              (root + "/src")
              (root + "/static")
              (root + "/tailwind.config.js")
              (root + "/templates")
            ]);
        };

        doCheck = true;

        nativeBuildInputs = [
          pkgs.tailwindcss
          pkgs.zola
        ];

        buildPhase = ''
          tailwindcss -i "$PWD/src/input.css" -o "$PWD/static/output.css" --minify
          zola build --output-dir public --force
        '';

        installPhase = ''
          cp -r public $out
        '';

        checkPhase = ''
          zola check
        '';

        meta = {
          inherit (zolaConfig) description;
          homepage = zolaConfig.base_url;
          maintainers = [lib.maintainers.onatustun];
        };
      };
    };
  };

  partitionedAttrs.apps = "dev";

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

        program = toString (pkgs.writers.writeNu "site" ''
          job spawn { ${lib.meta.getExe pkgs.zola} serve -i 0.0.0.0 -u localhost -p 3000 }
          ${lib.meta.getExe pkgs.tailwindcss} -i src/input.css -o static/output.css --watch
        '');
      };

      clean = {
        type = "app";
        meta.description = "Remove build artifacts";

        program = toString (pkgs.writers.writeNu "clean" ''
          rm -rf public static/output.css target
        '');
      };
    };

    checks = {
      default = self'.checks.site;
      inherit (self'.packages) site;
    };

    devShells.default = self'.devShells.site;
    make-shells.site.inputsFrom = [self'.packages.site];
  };
}
