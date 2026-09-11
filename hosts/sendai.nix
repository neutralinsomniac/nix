{ lib, inputs, ... }:
lib.mkHost {
  name = "sendai";
  extraModules = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
    (
      { lib, pkgs, ... }:
      {
        hardware.bluetooth.enable = true;
        boot.kernelPackages = pkgs.linuxPackages_latest;
        # disable panel self refresh (Lunar Lake uses the xe driver)
        boot.kernelParams = [ "xe.enable_psr=0" ];
        networking.networkmanager.wifi.powersave = false;
        services.fprintd.enable = true;
        # the reader intermittently wedges after suspend; keep it out of USB
        # autosuspend and stop fprintd before sleep so D-Bus activation
        # restarts it cleanly on resume
        # https://eldon.me/intermittent-fingerprint-reader-issue/
        services.udev.extraRules = ''
          ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="06cb", ATTR{idProduct}=="0123", ATTR{power/control}="on"
        '';
        systemd.services.fprintd = {
          conflicts = [ "sleep.target" ];
          before = [ "sleep.target" ];
        };
        useSecureBoot = true;
      }
    )
  ];
}
