{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-flow-gv302x-amdgpu
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  config = {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
