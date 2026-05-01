{ lib, inputs, ... }:
{
  flake.nixosConfigurations.corp = lib.mkHost {
    name = "corp";
    extraModules = [
      (inputs.self + "/hw/corp/disk-config.nix")
    ];
  };
}
