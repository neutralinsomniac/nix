{ inputs, ... }:
let inherit (import ./_lib.nix inputs) mkHost; in
{
  flake.nixosConfigurations.x1 = mkHost {
    name = "x1";
    extraModules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
    ];
  };
}
