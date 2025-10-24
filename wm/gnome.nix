{
  pkgs,
  pkgsUnstable,
  ...
}:
{
  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-terminal
    gnomeExtensions.appindicator
    gnome-themes-extra
    material-cursors
    pkgsUnstable.catppuccin-cursors.mochaDark
  ];
  services.udev.packages = [
    pkgs.gnome-settings-daemon
  ];
}
