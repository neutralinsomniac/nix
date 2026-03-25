{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  config = lib.mkIf (config.mywm == "niri") {
    security.polkit.enable = true; # polkit

    security = {
      pam = {
        services = {
          swaylock = { };
          "jeremy" = {
            kwallet = {
              enable = true;
              package = pkgs.kdePackages.kwallet-pam;
              forceRun = true;
            };
          };
        };
      };
    };

    xdg.portal.extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];

    programs.niri = {
      enable = true;
      package = inputs.nix-wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          spawn-at-startup = [
            "${pkgs.kdePackages.kwallet}/bin/kwalletd6"
            (lib.getExe noctalia)
          ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us";
          input.keyboard.xkb.variant = "colemak";
          input.keyboard.xkb.options = "ctrl:nocaps";
          input.touchpad = {
            tap = { };
            natural-scroll = { };
            drag = false;
          };

          layout.gaps = 5;

          # binds = {
          #   "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          #   "Mod+Q".close-window = null;
          #   "Mod+S".spawn-sh = "${lib.getExe noctalia} ipc call launcher toggle";
          # };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      noctalia
      alacritty
      fuzzel
      swaylock
      mako
      swayidle
    ];
  };
}
