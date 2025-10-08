{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-flow-gv302x-amdgpu
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  config = {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    # boot.kernelPackages = pkgs.linuxPackagesFor (
    #   pkgs.linux_6_16.override {
    #     argsOverride = rec {
    #       src = pkgs.fetchurl {
    #         url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    #         sha256 = "sha256-qfy7EKw3nbrLpjbi4zBzMxfU0AaXcNWsamETLyPH3IA=";
    #       };
    #       version = "6.17-rc7";
    #       modDirVersion = "6.17.0-rc7";
    #     };
    #   }
    # );

    hardware.asus.flow.gv302x.amdgpu.psr.enable = false;
    boot.kernelParams = [ "amdgpu.dcdebugmask=0x600" ];

    # boot.kernelPatches = [
    #   # {
    #   #   name = "sys-kernel_arch-sources-g14_files-0004-more-uarches-for-kernel-6.15";
    #   #   patch = ./patches/sys-kernel_arch-sources-g14_files-0004-more-uarches-for-kernel-6.15.patch;
    #   # }
    #   {
    #     name = "0001-acpi-proc-idle-skip-dummy-wait";
    #     patch = ./patches/0001-acpi-proc-idle-skip-dummy-wait.patch;
    #   }
    #   {
    #     name = "PATCH-v10-0-8-platform-x86-Add-asus-armoury-driver";
    #     patch = ./patches/PATCH-v10-0-8-platform-x86-Add-asus-armoury-driver.patch;
    #   }
    #   {
    #     name = "PATCH-v2-HID-amd_sfh-Enable-operating-mode";
    #     patch = ./patches/PATCH-v2-HID-amd_sfh-Enable-operating-mode.patch;
    #   }
    #   {
    #     name = "PATCH-v5-00-11-Improvements-to-S5-power-consumption";
    #     patch = ./patches/PATCH-v5-00-11-Improvements-to-S5-power-consumption.patch;
    #   }
    #   {
    #     name = "PATCH-platform-x86-asus-wmi-Fix-racy-registrations";
    #     patch = ./patches/PATCH-platform-x86-asus-wmi-Fix-racy-registrations.patch;
    #   }
    #   {
    #     name = "asus-patch-series";
    #     patch = ./patches/asus-patch-series.patch;
    #   }
    #   {
    #     name = "0004-asus-armoury_improve_xgm_support";
    #     patch = ./patches/0004-asus-armoury_improve_xgm_support.patch;
    #   }
    #   {
    #     name = "0003-asus-armoury_make_xg_mobile_plug-and-play";
    #     patch = ./patches/0003-asus-armoury_make_xg_mobile_plug-and-play.patch;
    #   }
    #   {
    #     name = "0070-acpi-x86-s2idle-Add-ability-to-configure-wakeup-by-A";
    #     patch = ./patches/0070-acpi-x86-s2idle-Add-ability-to-configure-wakeup-by-A.patch;
    #   }
    #   {
    #     name = "v2-0002-hid-asus-change-the-report_id-used-for-HID-LED-co";
    #     patch = ./patches/v2-0002-hid-asus-change-the-report_id-used-for-HID-LED-co.patch;
    #   }
    #   {
    #     name = "0040-workaround_hardware_decoding_amdgpu";
    #     patch = ./patches/0040-workaround_hardware_decoding_amdgpu.patch;
    #   }
    #   {
    #     name = "0081-amdgpu-adjust_plane_init_off_by_one";
    #     patch = ./patches/0081-amdgpu-adjust_plane_init_off_by_one.patch;
    #   }
    #   {
    #     name = "0084-enable-steam-deck-hdr";
    #     patch = ./patches/0084-enable-steam-deck-hdr.patch;
    #   }
    #   # {
    #   #   name = "PATCH-mm-Add-Kcompressd-for-accelerated-memory-compression";
    #   #   patch = ./patches/PATCH-mm-Add-Kcompressd-for-accelerated-memory-compression.patch;
    #   # }
    #   {
    #     name = "sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip";
    #     patch = ./patches/sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch;
    #   }
    #   {
    #     name = "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int";
    #     patch = ./patches/sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch;
    #   }
    # ];

    # we only have one graphics card; no need for this
    services.supergfxd.enable = false;

    # this driver is buggy as heck # maybe not on 6.17?
    # boot.blacklistedKernelModules = [ "hid_asus" ];

    hardware.bluetooth.enable = true;
  };
}
