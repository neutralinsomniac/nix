{ lib, config, ... }:
{
  config = lib.mkIf (config.mywm == "i3") {
    useKwallet = true;
    services.xserver.windowManager.i3.enable = true;
  };
}
