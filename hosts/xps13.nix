{ lib, ... }:
{
  flake.nixosConfigurations.xps13 = lib.mkHost { name = "xps13"; };
}
