{ inputs, ... }:
let inherit (import ./_lib.nix inputs) mkHost; in
{
  flake.nixosConfigurations.sgo = mkHost {
    name = "sgo";
    extraModules = [
      inputs.nixos-hardware.nixosModules.microsoft-surface-go
      (inputs.self + "/hw/sgo/disk-config.nix")
      { boot.kernelParams = [ "usbcore.autosuspend=-1" ]; }
    ];
  };
}
