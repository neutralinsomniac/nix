{ pkgs, lib, config, ... }:
{
  # PTP/MTP cameras (e.g. Nikon Z 9). libmtp doesn't know most cameras, so
  # go through libgphoto2: its udev rules tag any PTP-class device with
  # ID_GPHOTO2=1, which is what Solid/KDE need to show it as a camera.
  programs.gphoto2.enable = true;

  # camera:/ kio worker for Dolphin
  environment.systemPackages = lib.mkIf (config.mywm == "plasma") [
    pkgs.kdePackages.kamera
  ];
}
