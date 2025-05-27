{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        itensor = pkgs.callPackage ./itensor.nix { };
      in {
        packages.itensor = itensor;
        #packages.default = itensor;
        devShells.default = pkgs.mkShell { packages = [ ]; };
      });
}
