{ inputs, ... }:
let inherit (import ./_lib.nix inputs) mkHost; in
{
  flake.nixosConfigurations.micropc = mkHost {
    name = "micropc";
    extraModules = [
      inputs.nixos-hardware.nixosModules.gpd-micropc
      (inputs.self + "/hw/micropc/disk-config.nix")
      ({ lib, ... }: { services.xserver.xkb.variant = lib.mkForce ""; })
    ];
  };
}
