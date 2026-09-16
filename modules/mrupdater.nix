# MRUpdater — ModRetro Chromatic firmware updater.
#
# The upstream zip contains a single AppImage whose payload is a PyInstaller
# bundle of a PySide6 (Qt 6) app that talks to the device over libusb.
# wrapType2 provides the FHS-style runtime (Qt/X11/Wayland/GL); libusb1 and
# zlib are added on top.
#
# The app offers to install its own udev rules (99-modretro.rules, MODE 0666).
# We ship equivalent rules with the package instead, using the uaccess tag so
# only the active local session can open the device.
#
# At startup the app only tests whether /etc/udev/rules.d/99-modretro.rules
# exists (flashing_tool.initializer.ensure_udev_rules_exist), so it would keep
# nagging even though access works. Its own --disable_os_permissions_check
# flag skips exactly that test and nothing else on Linux, so the wrapper passes it.
#
# Device detection and flashing shell out to a *nested* AppImage
# (lib/openFPGALoader/openFPGALoader-x86_64.AppImage) that talks to the
# on-board Gowin programmer. FUSE is unavailable inside the bwrap sandbox, so
# the nested AppImage cannot mount itself and detection silently fails.
# APPIMAGE_EXTRACT_AND_RUN makes its runtime extract to $TMPDIR instead.
{ pkgs, lib, ... }:
let
  mrupdater =
    with pkgs;
    let
      pname = "mrupdater";
      # Upstream URL is unversioned; the hash is what pins the release.
      version = "2025-11-13";

      zip = fetchurl {
        url = "https://s3.us-east-1.amazonaws.com/updates.modretro.com/apps/MRUpdater-linux-x86_64.zip";
        hash = "sha256-Tq/8JK1Upjq5g64DJ488wBHEE1bxfLY8wcbh1swZNVE=";
      };

      appimage = runCommand "${pname}-${version}.AppImage" { nativeBuildInputs = [ unzip ]; } ''
        unzip -p ${zip} MRUpdater-linux-x86_64/MRUpdater-x86_64.AppImage > $out
        chmod +x $out
      '';

      appimageContents = appimageTools.extract {
        inherit pname version;
        src = appimage;
      };

      # Same device IDs as the bundled resources/linux/99-modretro.rules.
      # Must sort before 73-seat-late.rules for the uaccess tag to apply.
      udevRules = writeText "70-${pname}.rules" ''
        # ModRetro Chromatic
        SUBSYSTEM=="usb", ATTRS{idVendor}=="33aa", ATTRS{idProduct}=="0120", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="374e", ATTRS{idProduct}=="0101", TAG+="uaccess"
      '';
    in
    appimageTools.wrapType2 {
      inherit pname version;
      src = appimage;

      extraPkgs = pkgs: [
        libusb1
        zlib
      ];

      extraInstallCommands = ''
        install -Dm444 ${appimageContents}/MRUpdater.desktop \
          $out/share/applications/${pname}.desktop
        install -Dm444 ${appimageContents}/icon_256x256.png \
          $out/share/icons/hicolor/256x256/apps/${pname}.png
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail 'Exec=MRUpdater' 'Exec=${pname}' \
          --replace-fail 'Icon=icon_256x256' 'Icon=${pname}'

        install -Dm444 ${udevRules} $out/lib/udev/rules.d/70-${pname}.rules

        mv $out/bin/${pname} $out/bin/.${pname}-unwrapped
        cat > $out/bin/${pname} <<SH
        #!${runtimeShell}
        export APPIMAGE_EXTRACT_AND_RUN=1
        exec $out/bin/.${pname}-unwrapped --disable_os_permissions_check "\$@"
        SH
        chmod +x $out/bin/${pname}
      '';

      meta = with lib; {
        description = "Firmware updater for the ModRetro Chromatic";
        homepage = "https://modretro.com";
        license = licenses.unfree;
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        platforms = [ "x86_64-linux" ];
        mainProgram = pname;
      };
    };
in
lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
  environment.systemPackages = [ mrupdater ];
  services.udev.packages = [ mrupdater ];
}
