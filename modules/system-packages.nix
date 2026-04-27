{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.mosh.enable = true;
  networking.networkmanager.plugins = [ pkgs.networkmanager-openconnect ];

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
      inputs.exocortex.packages.${pkgs.stdenv.hostPlatform.system}.exo
      ffmpeg
      file
      gdb
      gh
      ghidra
      go
      gopls
      libreoffice
      # inputs.kte.packages.${pkgs.stdenv.hostPlatform.system}.full
      man-pages
      man-pages-posix
      minicom
      moonlight-qt
      mpv
      ncdu
      nixd
      nixfmt
      nixpkgs-review
      ocaml
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
      unzip
      vim
      wget
      wireshark
      wl-clipboard
      yt-dlp
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      discord
      # duckstation
      # tidal-hifi
      spotify
      (pkgs.callPackage pkgs.ida-pro {
        # Alternatively, fetch the installer through `fetchurl`, use a local path, etc.
        runfile = pkgs.fetchurl {
          url = "https://pintobyte.com/tmp/ida-pro_93_x64linux.run";
          hash = "sha256-LtQ65LuE103K5vAJkhDfqNYb/qSVL1+aB6mq4Wy3D4I=";
        };
      })
    ];

  fonts.packages = with pkgs; [
    ultimate-oldschool-pc-font-pack
  ];
}
