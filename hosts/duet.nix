{ lib, inputs, ... }:
lib.mkHost {
  name = "duet";
  system = "aarch64-linux";
  # 1920x1200 on 10.1"
  myHidpiScale = 2.0;
  extraModules = [
    # nixos-hardware profile for the MT8183 kukui-krane plus the U-Boot
    # depthcharge payload built from ~/src/krane.
    inputs.krane.nixosModules.krane
    (
      { lib, ... }:
      {
        # Keeps krane-install-uboot around for updating the bootloader
        # on the eMMC from the running system.
        hardware.lenovo.ideapad.duet.uboot.enable = true;

        # U-Boot's EFI variables do not persist (no U-Boot environment
        # storage), and the shared configuration.nix asserts the
        # opposite for the x86 hosts.
        boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

        # The shared config emulates aarch64 for building this very
        # system; pointless on the device itself.
        boot.binfmt.emulatedSystems = lib.mkForce [ ];
        nix.settings.extra-platforms = lib.mkForce [ ];

        # 4 GiB of RAM and an eMMC: swap to compressed memory rather
        # than wearing the flash.
        zramSwap.enable = true;

        system.stateVersion = lib.mkForce "25.11";
      }
    )
  ];
}
