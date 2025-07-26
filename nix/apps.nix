{
  perSystem = {
    self',
    pkgs,
    ...
  }: let
    inherit (pkgs) writeShellScript;
  in {
    apps = {
      default = self'.apps.site;

      site = {
        type = "app";

        program = "${writeShellScript "site" ''
          zola serve -i 0.0.0.0 -u localhost -p 3000 &
          tailwindcss -i src/input.css -o static/output.css --watch
          wait
        ''}";

        meta.description = "Development port and file watching";
      };

      clean = {
        type = "app";

        program = "${writeShellScript "clean" ''
          rm -rf public static/output.css target
        ''}";

        meta.description = "Remove build artifacts";
      };
    };
  };
}
