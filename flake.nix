{
  description = "neutralinsomniac's nix config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    # Remove once this PR (https://github.com/ghostty-org/ghostty/pull/4845) is merged
    ghostty-mjrochford = {
      url = "github:mjrochford/ghostty/xdg-system-config";
    };

    helix = {
      url = "github:helix-editor/helix";
    };

    jujutsu = {
      url = "github:jj-vcs/jj";
    };

    musnix = {
      url = "github:musnix/musnix";
    };

    ida-pro-overlay = {
      url = "github:msanft/ida-pro-overlay/v9.1.0.250226";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-index-database,
      ...
    }:
    let
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations =
        lib.genAttrs
          [
            "x270"
            "xps13"
            "x1"
            "theseus"
            "corp"
            "devnet"
            "micropc"
            "sgo"
          ]
          (
            hostName:
            lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = [
                { networking.hostName = hostName; }
                inputs.disko.nixosModules.disko
                ./hw/${hostName}
                ./configuration.nix
                nix-index-database.nixosModules.nix-index
                { programs.nix-index-database.comma.enable = true; }
                { system.configurationRevision = self.rev or "dirty"; }
              ];
            }
          );
    };
}
