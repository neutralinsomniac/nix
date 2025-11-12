{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
    pkgs.tidal-hifi

  ];
}
