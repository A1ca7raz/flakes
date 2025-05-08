{
  description = "A1ca7raz's NixOS Configuration";

  inputs = {
    pkgs.url = "github:A1ca7raz/nurpkgs";
    modules.url = "github:A1ca7raz/nur-modules";
    flamework.url = "github:A1ca7raz/flamework";
    # nix-secrets.url = "github:A1ca7raz/nix-secrets";
    nixpkgs.follows = "pkgs/nixpkgs";
    flake-parts.follows = "pkgs/flake-parts";
  };

  outputs =
    inputs@{ self, nixpkgs, flake-parts, flamework, ... }:
    let
      lib = flamework.lib nixpkgs.lib;
    in
    flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs = { inherit lib; };
    } {
      systems = [
        "x86_64-linux"
      ];

      imports = with flamework.flakeModules; [
        profiles
        modules
        packages
      ];

      flamework = {
        profiles = {
          profilesPath = ./profiles;
          presetsPath = ./profiles/__templates;
          constantsPath = ./constant;
          enableColmenaHive = true;
          # extraSpecialArgs = {
          #   inherit (inputs.nix-secrets) variables;
          # };
        };
        packages.pkgsPath = ./pkgs;
        modules.path = ./modules;
      };

      flake = {
        nixosModules = with inputs.pkgs.nixosModules; {
          colmena = colmena;
          home = home-manager;
          impermanence = impermanence;
          lanzaboote = lanzaboote;
          nix-index = nix-index-database;
          sops = sops;

          nur = { ... }: {
            imports = [
              default
              inputs.modules.nixosModules.all
            ];
          };
        };

        inherit (inputs.pkgs) homeModules;
      };

      perSystem = { config, pkgs, system, ... }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = [
            inputs.pkgs.overlays.default
            self.overlays.pkgs
          ];
        };

        formatter = pkgs.nixpkgs-fmt;

        devShells.default = with pkgs; mkShell {
          nativeBuildInputs = [
            colmena
            flameworkPackages.deploykit
          ];
        };
      };
    };

  nixConfig = {
    extra-substituters = [
      # "https://cache.garnix.io"
      "https://a1ca7raz-nur.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "a1ca7raz-nur.cachix.org-1:twTlSh62806B8lfG0QQzge4l5srn9Z8/xxyAFauOZnQ="
    ];
  };
}
