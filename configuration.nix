# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
in
{
  # this allows you to access `pkgsUnstable` anywhere in your config
  _module.args.pkgsUnstable = pkgsUnstable;

  imports = [
    ./modules
  ];

  mywm = "plasma";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "colemak";
      # capslock = control
      options = "ctrl:nocaps";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
    pkgs.cnijfilter2
  ];

  # discover network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # Enable sound with pipewire.
  # hardware.alsa.enablePersistence = true; # restore volume for non-pipewire-managed card settings
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    mouse.naturalScrolling = true;
    touchpad.naturalScrolling = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jeremy = {
    isNormalUser = true;
    description = "jeremy";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "audio"
    ];
    initialPassword = "password!";
  };

  environment.variables = {
    EDITOR = "hx";
    PAGER = "less -F";
  };

  # direnv
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.bash = {
    interactiveShellInit = ''
      source <(COMPLETE=bash jj)
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  # fwupd
  services.fwupd.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.ida-pro-overlay.overlays.default
  ];

  programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  # Add any missing dynamic libraries for unpackaged programs
  # here, NOT in environment.systemPackages
  # ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  programs.mosh.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      _0xproto
      aircrack-ng
      alsa-utils
      android-tools
      binwalk
      bitwarden-desktop
      blanket
      caligula
      catgirl
      chiaki-ng
      (chromium.override { enableWideVine = true; })
      clang
      darktable
      ethtool
      ettercap
      ffmpeg
      file
      gdb
      gh
      ghidra
      go
      gopls
      inputs.kte.packages.${pkgs.stdenv.hostPlatform.system}.full
      man-pages
      man-pages-posix
      minicom
      moonlight-qt
      mpv
      ncdu
      nixd
      nixfmt
      nixpkgs-review
      p7zip
      pipx
      protobuf
      python313
      inputs.raptorboost.packages.${pkgs.stdenv.hostPlatform.system}.default
      ripgrep
      signal-desktop
      sops
      sshfs
      ssh-to-age
      tcpdump
      tmux
      tytools # for uploading firmware to m8
      ultimate-oldschool-pc-font-pack
      unzip
      vdhcoapp
      vim
      wget
      wireshark
      wl-clipboard
      yt-dlp
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      discord
      duckstation
      # tidal-hifi
      spotify
      (pkgs.callPackage pkgs.ida-pro {
        # Alternatively, fetch the installer through `fetchurl`, use a local path, etc.
        runfile = pkgs.fetchurl {
          url = "https://pintobyte.com/tmp/ida-pro_92_x64linux.run";
          hash = "sha256-qt0PiulyuE+U8ql0g0q/FhnzvZM7O02CdfnFAAjQWuE=";
        };
      })
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  systemd.services.sshd.wantedBy = lib.mkForce [ ];

  # Open ports in the firewall.
  # 39849 = lxst
  networking.firewall.allowedTCPPorts = [
    39849
    8000
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "jeremy" ];
  };

  nix.channel.enable = false;

  # nix.settings.auto-optimise-store = true;
  # nix.gc = {
  #   automatic = true;
  #   dates = "daily";
  #   options = "--delete-older-than 7d";
  #   persistent = true;
  # };
}
