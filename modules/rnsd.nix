{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.rnsd;
in
{
  options.services.rnsd = {
    enable = lib.mkEnableOption "rnsd, the Reticulum Network Stack daemon";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.python3Packages.rns;
      defaultText = lib.literalExpression "pkgs.python3Packages.rns";
      description = "rns package providing the rnsd binary.";
    };

    settings = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      example = ''
        [reticulum]
          enable_transport = yes
          share_instance = yes

        [interfaces]
          [[Default Interface]]
            type = AutoInterface
            enabled = yes
      '';
      description = ''
        Contents of the Reticulum config file. When null, rnsd writes a
        default config to /var/lib/reticulum/config on first start, which
        can then be edited in place.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.reticulum = {
      isSystemUser = true;
      group = "reticulum";
      # serial access for RNode/USB radio interfaces
      extraGroups = [ "dialout" ];
    };
    users.groups.reticulum = { };

    systemd.services.rnsd = {
      description = "Reticulum Network Stack daemon";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = lib.optionalString (cfg.settings != null) ''
        ln -sf ${pkgs.writeText "reticulum-config" cfg.settings} /var/lib/reticulum/config
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/rnsd --config /var/lib/reticulum";
        User = "reticulum";
        Group = "reticulum";
        StateDirectory = "reticulum";
        Restart = "on-failure";
        RestartSec = 5;

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
      };
    };
  };
}
