{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
    (pkgs.callPackage pkgs.ida-pro {
      # Alternatively, fetch the installer through `fetchurl`, use a local path, etc.
      runfile = pkgs.fetchurl {
        url = "https://pintobyte.com/tmp/ida-pro_92_x64linux.run";
        hash = "sha256-qt0PiulyuE+U8ql0g0q/FhnzvZM7O02CdfnFAAjQWuE=";
      };
    })
  ];
}
