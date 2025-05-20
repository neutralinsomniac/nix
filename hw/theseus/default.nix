{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ../../configs/renoise.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];
  config = {
    hardware.framework.amd-7040.preventWakeOnAC = true;
    # hardware.framework.enableKmod = true;
    # hardware.framework.laptop13.audioEnhancement.enable = true;
    hardware.bluetooth.enable = true;
    # until the sddm issue gets fixed
    services.fprintd.enable = false;
    # boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_14;
  };
}
