{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = lib.mkIf (pkgs.stdenv.hostPlatform == "x86_64-linux") [
    pkgs.tidal-hifi

  ];
}
