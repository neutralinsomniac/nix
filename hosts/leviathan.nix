{ lib, inputs, ... }:
{
  flake.nixosConfigurations.leviathan = lib.mkHost {
    name = "leviathan";
    myHidpiScale = 1.5;
    extraModules = [
      inputs.nixos-hardware.nixosModules.asus-flow-gz302ea
      (inputs.self + "/hw/leviathan/disk-config.nix")
      {
        hardware.bluetooth.enable = true;

        # 0x10 = disable PSR, 0x400 = disable panel replay
        boot.kernelParams = lib.mkAfter [ "amdgpu.dcdebugmask=0x410" ];

        # kernel >7.2-rc1 where ism was rewritten
        boot.kernelPackages = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.linuxPackages_testing;

        # linux-firmware pinned past the 20260622 release for the DMCUB
        # 0.1.65.0 update (e3e36153, 2026-06-26, includes dcn_3_5_1)
        nixpkgs.overlays = [
          (final: prev: {
            linux-firmware = prev.linux-firmware.overrideAttrs (old: {
              version = "20260622-unstable-2026-06-26";
              src = final.fetchFromGitLab {
                owner = "kernel-firmware";
                repo = "linux-firmware";
                rev = "e3e36153ce3fff3f9c063dec7c267ce676a00a50";
                hash = "sha256-XtTS975qrdABk0xCnisBgCEGvCIRzkoupsimXXGSuBQ=";
              };
            });
          })
        ];

        # The GZ302EA folio touchpad is USB-attached, so systemd's input_id
        # builtin tags it as an *external* touchpad and libinput then hides "disable
        # while typing" (the KDE toggle is grayed out). libinput has no
        # touchpad-integration quirk key; the only supported override is the udev
        # property ID_INPUT_TOUCHPAD_INTEGRATION. Force it to internal so the
        # disable-while-typing toggle becomes available.
        services.udev.extraRules = ''
          ACTION=="add|change", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_TOUCHPAD}=="1", ENV{ID_VENDOR_ID}=="0b05", ENV{ID_MODEL_ID}=="1a30", ENV{ID_INPUT_TOUCHPAD_INTEGRATION}="internal"
        '';
      }
    ];
  };
}
