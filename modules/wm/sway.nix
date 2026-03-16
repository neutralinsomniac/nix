{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.mywm == "sway") {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      mako
    ];

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    services.gnome.gnome-keyring.enable = true;

    # autologin
    services.getty = {
      autologinUser = "jeremy";
      autologinOnce = true;
    };
    environment.loginShellInit = ''
      [[ "$(tty)" == /dev/tty1 ]] && sway
    '';
  };
}
