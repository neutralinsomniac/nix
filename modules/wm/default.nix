{ lib, ... }:
{
  imports = [
    ./cosmic.nix
    ./gnome.nix
    ./hyprland.nix
    ./i3_xfce.nix
    ./niri.nix
    ./plasma.nix
  ];

  options = {
    mywm = lib.mkOption {
      type = lib.types.enum [
        "cosmic"
        "gnome"
        "hyprland"
        "i3-xfce"
        "niri"
        "plasma"
        "windowmaker"
      ];
    };
  };
}
