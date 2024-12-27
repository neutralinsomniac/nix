{
  description = "neutralinsomniac's nix config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = lib.genAttrs [ "xps13" ] (hostName: lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ 
        { networking.hostName = hostName; }
        ./configuration.nix
      ];
    });
  };
}
