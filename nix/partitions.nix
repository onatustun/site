{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.flake-parts.flakeModules.partitions];

  partitionedAttrs = lib.attrsets.genAttrs [
    "apps"
    "checks"
    "devShells"
    "formatter"
  ] (lib.trivial.const "dev");

  partitions.dev.extraInputsFlake = ./_dev-flake;
}
