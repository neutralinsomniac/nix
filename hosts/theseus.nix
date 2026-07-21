{ lib, inputs, ... }:
lib.mkHost {
  name = "theseus";
  myHidpiScale = 1.5;
  extraModules = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    (
      { lib, pkgs, ... }:
      {
        hardware.framework.amd-7040.preventWakeOnAC = true;
        # hardware.framework.laptop13.audioEnhancement.enable = true;
        hardware.bluetooth.enable = true;
        boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.15") pkgs.linuxPackages_latest;
        networking.networkmanager.wifi.powersave = false;
        useSecureBoot = true;
      }
    )
  ];
}
