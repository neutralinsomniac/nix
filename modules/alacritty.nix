{ pkgs, config, ... }:
let
  # On wayland the compositor handles HiDPI (alacritty renders at logical
  # 12pt and the compositor scales). On X11 there's no compositor scaling,
  # so pre-multiply by the host's scale factor.
  baseFontSize = 12;
  fontSize =
    if config.myDisplayServer == "x11" then
      builtins.floor (baseFontSize * config.myHidpiScale + 0.5)
    else
      baseFontSize;
in
{
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "alacritty";
      paths = [ pkgs.alacritty ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/alacritty \
          --add-flags "--config-file /etc/alacritty/alacritty.toml"
      '';
    })
  ];

  environment.etc."alacritty/alacritty.toml".text = ''
    [font]
    size = ${toString fontSize}

    [font.normal]
    family = "Hack"
    style = "Regular"

    [keyboard]
    bindings = [ { key = "Return", mods = "Shift", chars = "\n" } ]
  '';
}
