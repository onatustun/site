{
  perSystem = {self', ...}: {
    checks = {
      default = self'.checks.site;
      inherit (self'.packages) site;
    };
  };
}
