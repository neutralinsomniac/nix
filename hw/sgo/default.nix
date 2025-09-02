{ inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.microsoft-surface-go
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  config = {
  };
}
