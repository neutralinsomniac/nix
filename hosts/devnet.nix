{ inputs, ... }:
let inherit (import ./_lib.nix inputs) mkHost; in
{
  flake.nixosConfigurations.devnet = mkHost {
    name = "devnet";
    extraModules = [
      (inputs.self + "/hw/devnet/disk-config.nix")
    ];
  };
}
