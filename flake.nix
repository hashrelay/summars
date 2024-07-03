{
  description = "A core lightning plugin to show a summary of your channels and optionally recent forwards, payments and/or paid invoices";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        craneLib = inputs.crane.mkLib pkgs;
        crate = craneLib.buildPackage {
          name = "summars";
          src = craneLib.cleanCargoSource (craneLib.path ./.);
        };
      in
      {
        checks = {
          inherit crate;
        };
        packages.default = crate;
        formatter = pkgs.nixpkgs-fmt;
        devShells.default = craneLib.devShell {
          checks = self.checks.${system};
        };
      });
}
