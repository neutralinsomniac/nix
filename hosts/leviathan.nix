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

        # The GZ302EA folio touchpad is USB-attached, so systemd's input_id
        # builtin tags it as an *external* touchpad and libinput then hides
        # "disable while typing" (the KDE toggle is grayed out). libinput has no
        # touchpad-integration quirk key; the only supported override is the udev
        # property ID_INPUT_TOUCHPAD_INTEGRATION. Force it to internal so the DWT
        # toggle becomes available. Gated on ID_INPUT_TOUCHPAD so the folio
        # keyboard (same 0b05:1a30 vid/pid) is unaffected; extraRules sort at 99,
        # after 60-input-id.rules sets external. The shipped libinput ASUS quirk
        # already marks the folio keyboard internal, so DWT works end-to-end.
        services.udev.extraRules = ''
          ACTION=="add|change", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_TOUCHPAD}=="1", ENV{ID_VENDOR_ID}=="0b05", ENV{ID_MODEL_ID}=="1a30", ENV{ID_INPUT_TOUCHPAD_INTEGRATION}="internal"
        '';
      }
    ];
  };
}
