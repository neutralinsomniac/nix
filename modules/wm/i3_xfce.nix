{ lib, config, ... }:
{
  config = lib.mkIf (config.mywm == "i3-xfce") {
    services.xserver = {
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      windowManager.i3.enable = true;
    };
    services.displayManager.defaultSession = "xfce+i3";
  };
}
