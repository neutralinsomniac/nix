{
  lib,
  inputs,
  ...
}:
lib.mkHost {
  name = "leviathan";
  myHidpiScale = 1.5;
  extraModules = [
    inputs.nixos-hardware.nixosModules.asus-flow-gz302ea
    (inputs.self + "/hw/leviathan/disk-config.nix")
    {
      environment.systemPackages = [
        inputs.slippi.packages."x86_64-linux".slippi-launcher
      ];
    }
  ];
}
