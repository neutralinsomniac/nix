{
  description = "neutralinsomniac's nix config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    helix = {
      url = "github:helix-editor/helix";
    };

    musnix  = {
      url = "github:musnix/musnix";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nix-index-database,
    ...
  }:
  let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = lib.genAttrs [ "x270" "xps13" "x1" "theseus" ] (hostName: lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
        { networking.hostName = hostName; }
        ./hw/${hostName}
        ./configuration.nix
        nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
      ];
    });
  };
}
