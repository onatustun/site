{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.flake-parts.flakeModules.partitions];

  partitionedAttrs = lib.attrsets.genAttrs [
    "apps"
    "checks"
  ] (lib.trivial.const "dev");

  partitions.dev.extraInputsFlake = ../dev-flake;
}
