{ lib, inputs, ... }:
{
  flake.nixosConfigurations.x1 = lib.mkHost {
    name = "x1";
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
    ];
  };
}
