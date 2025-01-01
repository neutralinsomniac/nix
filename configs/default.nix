{ ... }: {
  imports = [
    ./chromium.nix
    ./git.nix
    ./ghostty.nix
    ./helix.nix
    ./jj.nix
    ./firefox.nix
    ./ssh.nix
    ./steam.nix
    ./tailscale.nix
  ];
}
