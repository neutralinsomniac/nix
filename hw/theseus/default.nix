{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ./hardware-configuration.nix
    ./disable-wireless-powersave.nix
  ];

  config = {
    hardware.framework.amd-7040.preventWakeOnAC = true;
    # hardware.framework.laptop13.audioEnhancement.enable = true;
    hardware.bluetooth.enable = true;
    boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.15") pkgs.linuxPackages_latest;

    useSecureBoot = true;
  };
}
