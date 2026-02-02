{
  pkgs,
  lib,
  ...
}:
{
  programs.steam = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
    enable = true;
    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
}
