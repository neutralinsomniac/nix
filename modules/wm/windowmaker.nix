{ lib, config, ... }:
{
  config = lib.mkIf (config.mywm == "windowmaker") {
    services.xserver.windowManager.windowmaker.enable = true;
  };
}
