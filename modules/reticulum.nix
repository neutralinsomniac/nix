{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.python3Packages.nomadnet
    pkgs.python3Packages.rns
    pkgs.adafruit-nrfutil
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "python3.13-ecdsa-0.19.1"
  ];

  nixpkgs.overlays = [
    (import ../overlays/reticulum.nix)
  ];
}
