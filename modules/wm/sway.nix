{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.mywm == "sway") {
    useKwallet = true;

    environment.etc."sway/config".text = ''
      include /etc/sway/config.d/nixos.conf

      set $mod Mod1

      font pango:Hack 12

      workspace_auto_back_and_forth yes

      # Use Mouse+$mod to drag floating windows to their wanted position
      floating_modifier $mod

      # start a terminal
      bindsym $mod+Return exec alacritty

      # lock the screen
      set $lockcmd swaylock -f -c 000000 && swaymsg "output * power off" && swayidle -w timeout 1 'true' resume 'swaymsg "output * power on"; pkill -nx swayidle'
      bindsym $mod+Control+l exec $lockcmd
      bindsym XF86ScreenSaver exec $lockcmd

      # kill focused window
      bindsym $mod+Shift+C kill

      # start dmenu (a program launcher)
      bindsym $mod+p exec dmenu_run

      bindsym $mod+Tab workspace back_and_forth
      bindsym $mod+semicolon workspace back_and_forth

      # change focus
      bindsym $mod+h focus left
      bindsym $mod+j focus down
      bindsym $mod+k focus up
      bindsym $mod+l focus right

      # workspace next/prev
      bindsym XF86Forward workspace next_on_output
      bindsym XF86Back workspace prev_on_output
      #bindsym XF86Back exec i3lock -c 000000

      # move focused window
      bindsym $mod+Shift+H move left
      bindsym $mod+Shift+J move down
      bindsym $mod+Shift+K move up
      bindsym $mod+Shift+L move right

      # alternatively, you can use the cursor keys:
      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Down move down
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Right move right

      # split in horizontal orientation
      bindsym $mod+Shift+V split h

      # split in vertical orientation
      bindsym $mod+v split v

      # enter fullscreen mode for the focused container
      bindsym $mod+f fullscreen

      # change container layout (stacked, tabbed, default)
      bindsym $mod+s layout stacking
      bindsym $mod+w layout tabbed
      bindsym $mod+e layout default

      # toggle tiling / floating
      bindsym $mod+Shift+space floating toggle

      # change focus between tiling / floating windows
      bindsym $mod+space focus mode_toggle

      # focus the parent container
      bindsym $mod+a focus parent

      # focus the child container
      bindsym $mod+d focus child

      # switch to workspace
      bindsym $mod+1 workspace number 1:www
      bindsym $mod+2 workspace number 2:comm
      bindsym $mod+3 workspace number 3:mus
      bindsym $mod+4 workspace number 4:dev
      bindsym $mod+5 workspace number 5:mail
      bindsym $mod+6 workspace number 6
      bindsym $mod+7 workspace number 7
      bindsym $mod+8 workspace number 8
      bindsym $mod+9 workspace number 9:irc
      bindsym $mod+0 scratchpad show

      # move focused container to workspace
      bindsym $mod+Shift+1 move container to workspace number 1:www
      bindsym $mod+Shift+2 move container to workspace number 2:comm
      bindsym $mod+Shift+3 move container to workspace number 3:mus
      bindsym $mod+Shift+4 move container to workspace number 4:dev
      bindsym $mod+Shift+5 move container to workspace number 5:mail
      bindsym $mod+Shift+6 move container to workspace number 6
      bindsym $mod+Shift+7 move container to workspace number 7
      bindsym $mod+Shift+8 move container to workspace number 8
      bindsym $mod+Shift+9 move container to workspace number 9:irc
      bindsym $mod+Shift+0 move scratchpad

      # reload the configuration file
      #bindsym $mod+Shift+C reload
      # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
      bindsym $mod+Shift+R reload
      # exit i3 (logs you out of your X session)
      bindsym $mod+Shift+Q exit

      bindsym $mod+r exec i3-input -F 'rename workspace to "%s"' -P 'New name: '

      bindsym $mod+u [urgent="latest"] focus
      bindsym $mod+b border toggle

      default_border pixel 2
      default_floating_border pixel 2

      for_window [shell=".*"] inhibit_idle fullscreen

      exec nm-applet
      exec xsetroot -solid darkgrey
      exec swayidle -w \
          timeout 60 'brightnessctl -s set 10%' resume 'brightnessctl -r' \
          timeout 300 'swaylock -c 000000 -f' \
          timeout 305 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
          before-sleep 'swaylock -c 000000 -f'
      exec waybar -c /etc/waybar/config -s /etc/waybar/style.css

      client.focused #0088CC #0088CC #ffffff #dddddd
      client.focused_inactive #333333 #333333 #888888 #292d2e
      client.unfocused #333333 #333333 #888888 #292d2e
      client.urgent #2f343a #900000 #ffffff #900000

      # Brightness
      bindsym XF86MonBrightnessDown exec brightnessctl set 10%-
      bindsym XF86MonBrightnessUp exec brightnessctl set 10%+

      # Volume
      bindsym XF86AudioRaiseVolume exec 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+'
      bindsym XF86AudioLowerVolume exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'
      bindsym XF86AudioMute exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'

      input type:touchpad {
      	tap enabled
      	drag disabled
      	natural_scroll enabled
      	tap_button_map lrm
      }

      input type:keyboard {
      	xkb_layout "us"
      	xkb_variant "colemak"
      	xkb_options "ctrl:nocaps"
      	repeat_delay 300
        repeat_rate 30
      }

      output * scale ${toString config.myHidpiScale}

      seat "*" xcursor_theme Adwaita 24
    '';

    environment.etc."waybar/config".text = builtins.toJSON {
      layer = "top";
      position = "top";
      height = 22;
      fixed-center = false;
      expand-center = true;
      modules-left = [
        "sway/workspaces"
        "sway/mode"
        "custom/layout"
      ];
      modules-center = [ "sway/window" ];
      modules-right = [
        "pulseaudio"
        "battery"
        "clock"
        "tray"
      ];
      "sway/workspaces" = {
        disable-scroll = false;
        all-outputs = false;
      };
      "sway/mode" = {
        format = "{}";
      };
      "custom/layout" = {
        format = "[]=";
        tooltip = false;
      };
      "sway/window" = {
        format = "{title}";
        max-length = 200;
        expand = true;
      };
      tray = {
        icon-size = 16;
        spacing = 8;
      };
      pulseaudio = {
        format = "♪ {volume}%";
        format-muted = "♪ muted";
        scroll-step = 5;
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      battery = {
        format = "{capacity}% {time}";
        format-charging = "⚡ {capacity}% {time}";
        format-time = "{H}:{M:02}";
        states = {
          warning = 30;
          critical = 15;
        };
      };
      clock = {
        format = "{:%Y-%m-%d %H:%M}";
        interval = 30;
      };
    };

    environment.etc."waybar/style.css".text = ''
      * {
        font-family: Hack, monospace;
        font-size: 10pt;
        border: none;
        border-radius: 0;
        min-height: 0;
        margin: 0;
        padding: 0;
      }

      window#waybar {
        background-color: #222222;
        color: #bbbbbb;
      }

      #workspaces button {
        background-color: #222222;
        color: #bbbbbb;
        padding: 0 6px;
        border: none;
        border-radius: 0;
      }

      #workspaces button.visible {
        background-color: #222222;
        color: #bbbbbb;
      }

      #workspaces button.focused {
        background-color: #005577;
        color: #eeeeee;
      }

      #workspaces button.urgent {
        background-color: #ff0000;
        color: #ffffff;
      }

      #mode,
      #custom-layout {
        background-color: #222222;
        color: #bbbbbb;
        padding: 0 6px;
      }

      #window {
        background-color: #005577;
        color: #eeeeee;
        padding: 0 6px;
      }

      window#waybar.empty #window {
        background-color: #222222;
        color: #bbbbbb;
      }

      #tray,
      #pulseaudio,
      #battery,
      #clock {
        padding: 0 6px;
        color: #bbbbbb;
        background-color: #222222;
      }

      #tray menu {
        background-color: #222222;
        color: #bbbbbb;
      }

      #pulseaudio.muted {
        color: #ff5555;
      }

      #battery.charging {
        color: #88cc88;
      }

      #battery.warning {
        color: #ffaa00;
      }

      #battery.critical {
        color: #ff5555;
      }
    '';

    environment.systemPackages = [ pkgs.brightnessctl ];
    services.udev.packages = [ pkgs.brightnessctl ];

    fonts.packages = [
      pkgs.font-awesome
      pkgs.hack-font
    ];

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        adwaita-icon-theme
        dmenu
        wl-clipboard
        mako
        networkmanagerapplet
        waybar
        swaylock
        swayidle
      ];
    };

    # autologin
    services.getty = {
      autologinUser = "jeremy";
      autologinOnce = true;
    };
    environment.loginShellInit = ''
      [[ "$(tty)" == /dev/tty1 ]] && sway
    '';
  };
}
