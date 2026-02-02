{ lib, ... }:
{
  imports = [
    ./gnome.nix
    ./i3_xfce.nix
    ./hyprland.nix
    ./cosmic.nix
    ./plasma.nix
  ];

  options = {
    mywm = lib.mkOption {
      type = lib.types.enum [
        "cosmic"
        "gnome"
        "hyprland"
        "i3-xfce"
        "plasma"
      ];
    };
  };
}
