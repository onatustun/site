{
  inputs = {
    make-shell = {
      url = "github:nicknovitski/make-shell";
      inputs.flake-compat.follows = "dep_flake-compat";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";

      inputs = {
        flake-compat.follows = "dep_flake-compat";
        gitignore.follows = "de_gitignore";
        nixpkgs.follows = "de_nixpkgs";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "de_nixpkgs";
    };

    dep_flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    de_gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "de_nixpkgs";
    };

    de_nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
  };

  outputs = _: {};
}
