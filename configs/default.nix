{ ... }: {
  imports = [
    ./chromium.nix
    ./distrobox.nix
    ./git.nix
    ./ghostty.nix
    ./helix.nix
    ./jj.nix
    ./ssh.nix
    ./steam.nix
    ./tailscale.nix
    # ./wireplumber.nix
  ];
}
