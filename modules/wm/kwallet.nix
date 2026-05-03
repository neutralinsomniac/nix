{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    useKwallet = lib.mkEnableOption "use kwallet";
  };

  config = lib.mkIf config.useKwallet {
    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "KDE";
      KDE_SESSION_VERSION = "6";
    };
    environment.systemPackages = with pkgs; [
      kdePackages.kwallet
      kdePackages.kwalletmanager
      kdePackages.kwallet-pam
    ];
    security.pam.services.lightdm.kwallet.enable = true;
  };
}
