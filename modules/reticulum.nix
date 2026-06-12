{
  pkgs,
  ...
}:
{
  networking.firewall.allowedUDPPorts = [
    29716
    29717
    42671
  ];

  environment.systemPackages = [
    pkgs.python3Packages.nomadnet
    pkgs.python3Packages.rns
    pkgs.adafruit-nrfutil
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "python3.13-ecdsa-0.19.2"
  ];

  nixpkgs.overlays = [
    (import ../overlays/reticulum.nix)
  ];
}
