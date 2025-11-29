{
  perSystem = {
    self',
    pkgs,
    lib,
    ...
  }: {
    apps = {
      default = self'.apps.site;

      site = {
        type = "app";

        program = "${pkgs.writers.writeNu "site" ''
          job spawn { ${lib.meta.getExe pkgs.zola} serve -i 0.0.0.0 -u localhost -p 3000 }
          ${lib.meta.getExe pkgs.tailwindcss} -i src/input.css -o static/output.css --watch
        ''}";

        meta.description = "Development port and file watching";
      };

      clean = {
        type = "app";

        program = "${pkgs.writers.writeNu "clean" ''
          ${lib.meta.getExe' pkgs.coreutils "rm"} -rf public static/output.css target
        ''}";

        meta.description = "Remove build artifacts";
      };
    };
  };
}
