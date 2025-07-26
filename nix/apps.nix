{
  perSystem = {pkgs, ...}: {
    apps = let
      inherit (pkgs) writeShellScript;
    in {
      default = {
        type = "app";

        program = "${writeShellScript "dev" ''
          zola serve -i 0.0.0.0 -u localhost -p 3000 &
          typst watch ../src/cv.typ ../static/cv.pdf &
          tailwindcss -i ../src/input.css -o ../static/output.css --watch
        ''}";
      };

      clean = {
        type = "app";

        program = "${writeShellScript "clean" ''
          rm -rf public/
          rm -rf static/cv.pdf
          rm -rf static/output.css
          rm -rf target/
        ''}";
      };
    };
  };
}
