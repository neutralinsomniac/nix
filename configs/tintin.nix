{
  pkgs,
  # inputs,
  ...
}:
let
  ttPkg = pkgs.tintin;

  ttconfig = pkgs.writeText "tt.rc" ''
    #split
    #high {%*Kanto%*} {reverse light red}
    #prompt {[%d/%d %d/%d %d/%d %d]} {[<019>%1/%2 <049>%3/%4 <029>%5/%6 <059>%7<079>]$ } {-1} {0}
    #session aard aardmud.org 4000
  '';

  tt = pkgs.writeShellScriptBin "tt" ''
    ${ttPkg}/bin/tt++ ${ttconfig}
  '';

in
{
  config = {
    environment.systemPackages = [ tt ];
  };
}
