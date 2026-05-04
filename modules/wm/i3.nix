{ lib, config, ... }:
{
  config = lib.mkIf (config.mywm == "i3") {
    services.xserver.windowManager.i3.enable = true;
  };
}
