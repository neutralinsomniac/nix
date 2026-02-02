{ lib, config, ... }:
{
  config = lib.mkIf (config.mywm == "plasma") {
    # plasma6
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    # programs.kdeconnect.enable = true;
  };
}
