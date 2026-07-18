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
        # useSecureBoot = true;
      }
    )
  ];
}
