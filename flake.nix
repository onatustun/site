{
  description = "zola environment";

  nixConfig = {
    extra-substituters = [
      "https://alejandra.cachix.org"
      "https://cache.garnix.io"
      "https://cachix.cachix.org"
      "https://deadnix.cachix.org"
      "https://flake-parts.cachix.org"
      "https://hercules-ci.cachix.org"
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
    ];

    extra-trusted-public-keys = [
      "alejandra.cachix.org-1:NjZ8kI0mf4HCq8yPnBfiTurb96zp1TBWl8EC54Pzjm0="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "deadnix.cachix.org-1:R7kK+K1CLDbLrGph/vSDVxUslAmq8vhpbcz6SH9haJE="
      "flake-parts.cachix.org-1:IlewuHm3lWYND+tOeQC9nySl7JpzTZ4sqkb1eJMafow="
      "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];

    builders-use-substitutes = true;

    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];

    flake-registry = "";
    show-trace = true;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };

    systems.url = "github:nix-systems/default";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";

      inputs = {
        flake-compat.follows = "flake-compat";
        gitignore.follows = "gitignore";
        nixpkgs.follows = "nixpkgs";
      };
    };

    rust-analyzer-src = {
      url = "github:rust-lang/rust-analyzer";
      flake = false;
    };

    fenix = {
      url = "github:nix-community/fenix";

      inputs = {
        rust-analyzer-src.follows = "rust-analyzer-src";
        nixpkgs.follows = "nixpkgs";
      };
    };

    alejandra = {
      url = "github:kamadorueda/alejandra";

      inputs = {
        fenix.follows = "fenix";
        flakeCompat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };

    deadnix = {
      url = "github:astro/deadnix";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    systems,
    ...
  }: let
    inherit (flake-parts.lib) mkFlake;
    inherit (nixpkgs.lib) filesystem filter hasSuffix;
    inherit (filesystem) listFilesRecursive;
  in
    mkFlake {inherit inputs;} {
      debug = true;
      systems = import systems;

      imports =
        ./nix
        |> listFilesRecursive
        |> filter (hasSuffix ".nix");
    };
}
