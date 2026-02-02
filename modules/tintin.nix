{
  pkgs,
  # inputs,
  ...
}:
let
  ttPkg = pkgs.tintin;

  ttconfig = pkgs.writeText "tt.rc" ''
    #split
    #high {%*Spouse%*} {reverse}
    #prompt {%*[%d/%d %d/%d %d/%d %d]} {<788>%1<079>[<019>%2/%3 <049>%4/%5 <029>%6/%7 <059>%8<079>]$ } {-1} {0}
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
