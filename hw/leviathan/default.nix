{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-flow-gv302x-amdgpu
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  config = {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    hardware.asus.flow.gv302x.amdgpu.psr.enable = false;
    boot.kernelParams = [ "amdgpu.dcdebugmask=0x600" ];

    # this driver is buggy as heck
    boot.blacklistedKernelModules = [ "hid_asus" ];

    hardware.bluetooth.enable = true;
  };
}
