{ inputs, ... }:
let inherit (import ./_lib.nix inputs) mkHost; in
{
  flake.nixosConfigurations.x270 = mkHost { name = "x270"; };
}
