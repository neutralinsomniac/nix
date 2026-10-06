{ ... }:
{
  # Kyocera E4710 (DuraXV LTE, Android 5.1) enumerates as mtp,adb. libmtp
  # doesn't know the device, so KDE's kmtpd (in kiod6) fails to open an MTP
  # session, resets the USB device, and the phone re-enumerates every ~30 s,
  # taking adb down with it. 69-libmtp.rules tags it from mtp-probe; strip the
  # tags again here (99-local.rules runs later) so Solid never hands it to
  # kmtpd. adb is unaffected.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="0482", ATTR{idProduct}=="0a9b", ENV{ID_MTP_DEVICE}="", ENV{ID_MEDIA_PLAYER}=""
  '';
}
