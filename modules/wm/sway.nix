{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.mywm == "sway") {
    useKwallet = true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
      mako
    ];

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

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
