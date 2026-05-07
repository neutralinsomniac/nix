{
  pkgs,
  config,
  lib,
  ...
}:
let
  scale = config.myHidpiScale;
  roundInt = x: builtins.floor (x + 0.5);
  dpi = roundInt (96.0 * scale);
  cursorSize = roundInt (24.0 * scale);
in
{
  config = lib.mkIf (config.mywm == "i3") {
    useKwallet = true;

    services.xserver.windowManager.i3.configFile = pkgs.writeText "i3-config" ''
      set $mod Mod1

      font pango:Hack 12

      workspace_auto_back_and_forth yes

      # Use Mouse+$mod to drag floating windows to their wanted position
      floating_modifier $mod

      # start a terminal
      bindsym $mod+Return exec alacritty

      # lock the screen
      set $lockcmd i3lock -c 000000
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

      exec --no-startup-id nm-applet
      exec --no-startup-id xsetroot -solid darkgrey
      exec_always --no-startup-id xsetroot -cursor_name left_ptr
      exec --no-startup-id xrandr --dpi ${toString dpi}
      exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock -c 000000
      exec --no-startup-id xautolock -time 5 -locker "i3lock -c 000000" -detectsleep
      exec --no-startup-id xset s 300 305 dpms 305 305 305

      client.focused #0088CC #0088CC #ffffff #dddddd
      client.focused_inactive #333333 #333333 #888888 #292d2e
      client.unfocused #333333 #333333 #888888 #292d2e
      client.urgent #2f343a #900000 #ffffff #900000

      bar {
        status_command i3status -c /etc/i3status.conf
        position top
        font pango:Hack 12
        tray_output primary
        colors {
          background #222222
          statusline #bbbbbb
          separator #444444
          focused_workspace  #005577 #005577 #eeeeee
          active_workspace   #222222 #222222 #bbbbbb
          inactive_workspace #222222 #222222 #bbbbbb
          urgent_workspace   #ff0000 #ff0000 #ffffff
          binding_mode       #ff0000 #ff0000 #ffffff
        }
      }

      # Brightness
      bindsym XF86MonBrightnessDown exec brightnessctl set 10%-
      bindsym XF86MonBrightnessUp exec brightnessctl set 10%+

      # Volume
      bindsym XF86AudioRaiseVolume exec 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+'
      bindsym XF86AudioLowerVolume exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'
      bindsym XF86AudioMute exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'
    '';

    environment.etc."X11/Xcursor.ad".text = ''
      Xcursor.theme: Adwaita
      Xcursor.size: ${toString cursorSize}
    '';

    environment.etc."i3status.conf".text = ''
      general {
        output_format = "i3bar"
        colors = true
        interval = 5
        color_good = "#bbbbbb"
        color_bad = "#ff5555"
        color_degraded = "#ffaa00"
      }

      order += "volume master"
      order += "battery 0"
      order += "tztime local"

      volume master {
        format = "♪ %volume"
        format_muted = "♪ muted"
        device = "pulse"
      }

      battery 0 {
        format = "%status %percentage %remaining"
        format_down = ""
        status_chr = "⚡"
        status_bat = ""
        status_unk = "?"
        status_full = ""
        low_threshold = 15
        threshold_type = percentage
        last_full_capacity = true
      }

      tztime local {
        format = "%Y-%m-%d %H:%M"
      }
    '';

    services.xserver.windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        adwaita-icon-theme
        dmenu
        i3lock
        i3status
        networkmanagerapplet
        xautolock
        xss-lock
      ];
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
      xclip
    ];
    services.udev.packages = [ pkgs.brightnessctl ];

    fonts.packages = [
      pkgs.font-awesome
      pkgs.hack-font
    ];

    services.xserver.displayManager.lightdm.enable = true;

    # Load Xcursor resources before i3 starts. xcb-util-cursor (used by i3bar
    # and many libxcursor apps) reads Xresources at startup, so loading them
    # via i3's exec_always is too late — i3bar reads an empty xrdb and falls
    # back to 16px legacy cursor.
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge /etc/X11/Xcursor.ad
    '';

    # Force winit to scale=1 so alacritty renders at the raw point size
    # (21pt) and doesn't scale the cursor. Without this, winit auto-detects
    # ~2.35x from the panel's EDID DPI and double-scales everything.
    #
    # XCURSOR_THEME/SIZE: chromium and Electron apps (Signal etc.) don't
    # read Xcursor.* xresources — they use these env vars (or fall back to
    # their own defaults). xrdb covers everything else; these cover them.
    environment.sessionVariables = {
      WINIT_X11_SCALE_FACTOR = "1";
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = toString cursorSize;
    };
  };
}
