{
  perSystem = {pkgs, ...}: let
    inherit (pkgs) writeShellScript;
  in {
    apps = {
      default = {
        type = "app";

        program = "${writeShellScript "dev" ''
          zola serve -i 0.0.0.0 -u localhost -p 3000 &
          tailwindcss -i src/input.css -o static/output.css --watch
          wait
        ''}";
      };

      clean = {
        type = "app";

        program = "${writeShellScript "clean" ''
          rm -rf public static/cv.pdf static/output.css target
        ''}";
      };
    };
  };
}
