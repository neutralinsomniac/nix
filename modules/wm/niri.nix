{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.mywm == "niri") {
    programs.niri = {
      enable = true;
    };

    environment.systemPackages = [
      pkgs.fuzzel
      pkgs.alacritty
    ];
  };
}
