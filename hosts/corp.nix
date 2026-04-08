{ inputs, ... }:
let inherit (import ./_lib.nix inputs) mkHost; in
{
  flake.nixosConfigurations.corp = mkHost {
    name = "corp";
    extraModules = [
      (inputs.self + "/hw/corp/disk-config.nix")
    ];
  };
}
