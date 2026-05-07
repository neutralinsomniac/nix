{ lib, config, ... }:
let
  dir = builtins.readDir ./.;
  toImport =
    name: type:
    let
      path = ./. + "/${name}";
    in
    if name == "default.nix" then
      [ ]
    else if lib.hasPrefix "_" name then
      [ ]
    else if type == "regular" && lib.hasSuffix ".nix" name then
      [ path ]
    else
      [ ];

  waylandWMs = [
    "cosmic"
    "gnome"
    "hyprland"
    "niri"
    "plasma"
    "sway"
  ];
in
{
  imports = lib.flatten (lib.mapAttrsToList toImport dir);

  options.mywm = lib.mkOption {
    type = lib.types.enum [
      "cosmic"
      "enlightenment"
      "gnome"
      "hyprland"
      "i3"
      "niri"
      "plasma"
      "sway"
      "tile"
      "windowmaker"
    ];
  };

  options.myDisplayServer = lib.mkOption {
    type = lib.types.enum [
      "x11"
      "wayland"
    ];
    description = ''
      Display server the active `mywm` runs under. Auto-derived but
      overridable (e.g. running gnome/plasma on X11 instead of wayland).
    '';
  };

  options.myHidpiScale = lib.mkOption {
    type = lib.types.float;
    default = 1.0;
    description = ''
      HiDPI scale factor for this host. Drives sway's `output * scale`,
      i3's xrandr DPI, alacritty font size on X11, and Xcursor.size.
      Set to e.g. 1.75 on hidpi laptops; leave at 1.0 on standard displays.
    '';
  };

  config.myDisplayServer = lib.mkDefault (
    if builtins.elem config.mywm waylandWMs then "wayland" else "x11"
  );
}
