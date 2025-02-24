# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, ... }:

{
  # this allows you to access `pkgsUnstable` anywhere in your config
  _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  imports =
    [
      ./wm/plasma.nix
      ./configs
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  # discover network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
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
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [
    ];
  };

  environment.variables = {
    EDITOR = "hx";
    PAGER = "less -F";
  };

  # direnv
  programs.direnv.enable = true;

  programs.command-not-found.enable = false;
  programs.bash = {
    interactiveShellInit = ''
      source <(jj util completion bash)
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
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
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    (callPackage ida-pro {
     # Alternatively, fetch the installer through `fetchurl`, use a local path, etc.
     runfile = fetchurl {
        url = "https://pintobyte.com/tmp/ida-pro_90sp1_x64linux.run";
        hash = "sha256-wOLV9BD4pKN0W7IZ2CHWkM4XaKXOCiXobgwwwf5ZnHE=";
      };
    })

    _0xproto
    alsa-utils
    binwalk
    bitwarden-desktop
    blanket
    canon-cups-ufr2
    cargo
    chromium
    clang
    discord
    file
    gdb
    gh
    go
    moonlight-qt
    mosh
    mpv
    ncdu
    nixpkgs-review
    p7zip
    pipx
    python313
    rustc
    signal-desktop
    spotify
    tidal-hifi
    tmux
    tytools # for uploading firmware to m8
    unzip
    vdhcoapp
    vim
    wget
    wl-clipboard
    yt-dlp
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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes"];
  # nix.settings.auto-optimise-store = true;
  # nix.gc = {
  #   automatic = true;
  #   dates = "daily";
  #   options = "--delete-older-than 7d";
  #   persistent = true;
  # };
}
