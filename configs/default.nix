{ ... }: {
  imports = [
    ./chromium.nix
    ./disk-config.nix # for nixos-anywhere
    ./distrobox.nix
    ./git.nix
    ./ghostty.nix
    ./helix.nix
    ./jj.nix
    # ./openra.nix
    # ./renoise.nix
    ./ssh.nix
    ./steam.nix
    ./tailscale.nix
    # ./virtualbox.nix
    # ./wireplumber.nix
  ];
}
