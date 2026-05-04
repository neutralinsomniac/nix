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
    environment.systemPackages = with pkgs; [
      kdePackages.kwallet
      kdePackages.kwalletmanager
      kdePackages.kwallet-pam
    ];
    security.pam.services.lightdm.kwallet.enable = true;
  };
}
