{ inputs, ... }:
let inherit (import ./_lib.nix inputs) mkHost; in
{
  flake.nixosConfigurations.xps13 = mkHost { name = "xps13"; };
}
