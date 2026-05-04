{ lib, ... }:
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
}
