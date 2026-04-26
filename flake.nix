{
  description = "neutralinsomniac's nix config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-2505.url = "nixpkgs/nixos-25.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nix-wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    nix-wrapper-modules.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-apple-silicon.url = "github:nix-community/nixos-apple-silicon";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    ghostty.url = "github:ghostty-org/ghostty";

    helix.url = "github:helix-editor/helix";

    jujutsu.url = "github:jj-vcs/jj";

    ida-pro-overlay.url = "github:msanft/ida-pro-overlay/v9.2.0.250908";
    ida-pro-overlay.inputs.nixpkgs.follows = "nixpkgs";

    kte.url = "git+https://git.wntrmute.dev/kyle/kte";
    kte.inputs.nixpkgs.follows = "nixpkgs";

    raptorboost.url = "github:neutralinsomniac/raptorboost";
    raptorboost.inputs.nixpkgs.follows = "nixpkgs";

    exocortex.url = "github:neutralinsomniac/exocortex";
    exocortex.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; }
    (inputs.import-tree ./hosts);
}
