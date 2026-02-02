{ lib, config, ... }:
{
  config = lib.mkIf (config.mywm == "hyprland") {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
