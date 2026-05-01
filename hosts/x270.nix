{ lib, ... }:
{
  flake.nixosConfigurations.x270 = lib.mkHost { name = "x270"; };
}
