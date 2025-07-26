{
  perSystem = {self', ...}: {
    checks = {
      default = self'.checks.site;
      site = self'.packages.site;
    };
  };
}
