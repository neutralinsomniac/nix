{
  inputs,
  pkgs,
  ...
}:
let
  webkitgtk_4_0 = inputs.nixpkgs-2505.legacyPackages.${pkgs.stdenv.hostPlatform.system}.webkitgtk_4_0;
  playdate-mirror =
    with pkgs;
    stdenv.mkDerivation {
      pname = "playdate-mirror";
      version = "1.3.0";
      src = fetchurl {
        url = "https://download-cdn.panic.com/mirror/Linux/Mirror-1.3.0.tar.gz";
        hash = "sha256-JQNpl5UKaoEpj5wvp6k2iZ7qyKXpWiIG/z8nHt0+l38=";
      };
      buildInputs = [
        autoPatchelfHook
        cairo
        gdk-pixbuf
        glib
        gtk3
        pango
        stdenv.cc.cc.lib
        systemdLibs
        webkitgtk_4_0
        xorg.libX11
      ];
      installPhase = "mkdir -p $out/bin; cp mirror $out/bin";
    };
in
{
  environment.systemPackages = [ playdate-mirror ];
}
