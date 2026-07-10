{
  pkgs,
  pkgsUnstable,
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
      bison
      blanket
      bubblewrap
      caligula
      catgirl
      chiaki-ng
      (chromium.override {
        enableWideVine = true;
        commandLineArgs = "--password-store=kwallet6";
      })
      clang
      darktable
      ethtool
      ettercap
      inputs.exocortex.packages.${pkgs.stdenv.hostPlatform.system}.exo
      ffmpeg
      file
      flex
      gcc
      gdb
      gh
      ghidra
      gnumake
      go
      gopls
      inetutils
      libreoffice
      # inputs.kte.packages.${pkgs.stdenv.hostPlatform.system}.full
      man-pages
      man-pages-posix
      minicom
      moonlight-qt
      mpv
      multipath-tools
      ncdu
      nixd
      nixfmt
      nixpkgs-review
      nodejs
      ocaml
      openssl
      p7zip
      (pipx.overridePythonAttrs (old: {
        disabledTests = (old.disabledTests or [ ]) ++ [
          "test_fix_package_name"
          "test_parse_specifier_for_metadata"
        ];
      }))
      protobuf
      python313
      inputs.raptorboost.packages.${pkgs.stdenv.hostPlatform.system}.default
      ripgrep
      rtorrent
      (signal-desktop.override {
        commandLineArgs = "--password-store=kwallet6";
      })
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
      zip
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
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts.hack
  ];
}
