{
  pkgs,
  ...
}:
let
  ttPkg = pkgs.tintin;

  ttconfig = ./config;

  tt = pkgs.writeShellScriptBin "tt" ''
    ${ttPkg}/bin/tt++ ${ttconfig}
  '';
in
{
  config = {
    environment.systemPackages = [ tt ];
  };
}
