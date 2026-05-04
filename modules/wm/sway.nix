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
        bindsym $mod+Control+l exec swaylock -c 000000
        bindsym XF86ScreenSaver exec swaylock -c 000000

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

        exec nm-applet
        exec xsetroot -solid darkgrey

        # Start i3bar to display a workspace bar (plus the system information i3status
        # finds out, if available)
        bar {
          swaybar_command swaybar
          status_command i3status -c /etc/i3status.conf
      		position top
          font pango:Hack 12
          colors {
            separator #666666
            background #222222
            statusline #dddddd
            focused_workspace #0088CC #0088CC #ffffff
            active_workspace #333333 #333333 #ffffff
            inactive_workspace #333333 #333333 #888888
            urgent_workspace #2f343a #900000 #ffffff
          }
        }
        client.focused #0088CC #0088CC #ffffff #dddddd
        client.focused_inactive #333333 #333333 #888888 #292d2e
        client.unfocused #333333 #333333 #888888 #292d2e
        client.urgent #2f343a #900000 #ffffff #900000

        # Brightness
        bindsym XF86MonBrightnessDown exec light -U 10
        bindsym XF86MonBrightnessUp exec light -A 10

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

        output * scale 1.75

        seat "*" xcursor_theme Adwaita 24
    '';

    environment.etc."i3status.conf".text = ''
      general {
        output_format = "i3bar"
        colors = true
        interval = 5
      }

      order += "volume master"
      order += "battery all"
      order += "tztime local"

      volume master {
        format = "♪ %volume"
        format_muted = "♪ muted"
        device = "pulse"
      }

      battery all {
        format = "%status %percentage %remaining"
        low_threshold = 15
      }

      tztime local {
        format = "%Y-%m-%d %H:%M"
      }
    '';

    programs.light.enable = true;

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
        i3status
        swaylock
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
