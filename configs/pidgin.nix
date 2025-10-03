{
  pkgs,
  ...
}:
let
  pidginBonjourPort = 5298;
in
{
  environment.systemPackages = [
    pkgs.pidgin
  ];

  networking.firewall.allowedTCPPorts = [ pidginBonjourPort ];
  networking.firewall.allowedUDPPorts = [ pidginBonjourPort ];
}
