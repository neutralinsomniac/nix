{ inputs, lib, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.gpd-micropc
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  config = {
    services.xserver.xkb.variant = lib.mkForce "";
  };
}
