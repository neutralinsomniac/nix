{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.musnix.nixosModules.musnix ];
  musnix.enable = true;
  musnix.kernel.realtime = true;
  environment.systemPackages = [ pkgs.renoise ];
}
