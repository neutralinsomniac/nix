{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.steam = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
    enable = true;
    # Steam's CEF/Chromium UI (steamwebhelper) renders an invisible window with
    # GPU acceleration on amdgpu + Plasma Wayland/Xwayland; force software UI rendering.
    # Only affects the Steam client UI, not games.
    package =
      if (config.networking.hostName == "theseus") then
        (pkgs.steam.override {
          extraArgs = "-cef-disable-gpu";
        })
      else
        pkgs.steam;

    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
}
