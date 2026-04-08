{ inputs, ... }:
let inherit (import ./_lib.nix inputs) mkHost; in
{
  flake.nixosConfigurations.theseus = mkHost {
    name = "theseus";
    extraModules = [
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      (inputs.self + "/hw/theseus/disable-wireless-powersave.nix")
      (
        { lib, pkgs, ... }:
        {
          hardware.framework.amd-7040.preventWakeOnAC = true;
          # hardware.framework.laptop13.audioEnhancement.enable = true;
          hardware.bluetooth.enable = true;
          boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.15") pkgs.linuxPackages_latest;
          useSecureBoot = true;
        }
      )
    ];
  };
}
