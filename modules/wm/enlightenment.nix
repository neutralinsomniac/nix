{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.mywm == "enlightenment") {
    services.xserver.desktopManager.enlightenment.enable = true;
    environment.enlightenment.excludePackages = [ pkgs.enlightenment.econnman ];
  };
}
