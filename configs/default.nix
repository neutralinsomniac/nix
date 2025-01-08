{ ... }: {
  imports = [
    ./chromium.nix
    ./docker.nix
    ./git.nix
    ./ghostty.nix
    ./helix.nix
    ./jj.nix
    ./ssh.nix
    ./steam.nix
    ./tailscale.nix
  ];
}
