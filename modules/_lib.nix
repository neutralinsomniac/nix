inputs: {
  mkHost =
    {
      name,
      system ? "x86_64-linux",
      nixpkgs ? inputs.nixpkgs,
      mywm ? "plasma",
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        {
          networking.hostName = name;
          mywm = mywm;
        }
        inputs.disko.nixosModules.disko
        (inputs.self + "/hw/${name}/hardware-configuration.nix")
        (inputs.self + "/configuration.nix")
        inputs.nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
        { system.configurationRevision = inputs.self.rev or "dirty"; }
      ]
      ++ extraModules;
    };
}
