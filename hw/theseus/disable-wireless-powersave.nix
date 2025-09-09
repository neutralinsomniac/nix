{ pkgs, ... }:
{
  systemd.services."disable-wifi-powersave" = {
    enable = true;
    description = "Disable Wireless Powersaving";
    after = [ "sys-subsystem-net-devices-wlp1s0.device" ];

    wantedBy = [ "sys-subsystem-net-devices-wlp1s0.device" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.iw}/bin/iw dev wlp1s0 set power_save off";
    };
  };
}
