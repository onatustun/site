{
  perSystem = {pkgs, ...}: {
    apps = {
      dev = {
        type = "app";

        program = "${pkgs.writeShellScript "dev" ''
          zola serve -i 0.0.0.0 -u localhost -p 3000 &
          typst watch ./cv.typ ./static/cv.pdf &
          tailwindcss -i ./input.css -o ./static/output.css --watch
        ''}";
      };

      clean = {
        type = "app";

        program = "${pkgs.writeShellScript "clean" ''
          rm -rf public/
          rm -rf static/cv.pdf
          rm -rf static/output.css
          rm -rf target/
        ''}";
      };
    };
  };
}
