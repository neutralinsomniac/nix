# Lenovo IdeaPad Duet Chromebook (MT8183 kukui-krane), internal eMMC.
#
# Partition layout written at install time (see the nixos-hardware
# lenovo/ideapad/duet README): depthcharge payload, ESP, ext4 root.
# The board-specific initrd modules, kernel parameters and bootloader
# settings come from the krane profile, not from here.
{
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/krane-nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/KRANE_ESP";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
