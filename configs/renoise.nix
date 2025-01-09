{
  inputs
, pkgs
, ...
}:
{
  imports = [ inputs.musnix.nixosModules.musnix ];
  musnix.enable = true;
  environment.systemPackages = [ pkgs.renoise ];
}
