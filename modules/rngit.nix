{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.rngit;
in
{
  # rngit depends on the rnsd module for the shared Reticulum instance;
  # the module system dedupes this with the auto-import in default.nix
  imports = [ ./rnsd.nix ];

  options.services.rngit = {
    enable = lib.mkEnableOption "rngit, the Reticulum git repository node";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.python3Packages.rns;
      defaultText = lib.literalExpression "pkgs.python3Packages.rns";
      description = "rns package providing the rngit binary.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.rnsd.enable;
        message = "services.rngit requires services.rnsd for the shared Reticulum instance";
      }
    ];

    systemd.services.rngit = {
      description = "Reticulum git repository node";
      requires = [ "rnsd.service" ];
      after = [ "rnsd.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.git ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/rngit --config /var/lib/rngit --rnsconfig /var/lib/reticulum";
        User = "reticulum";
        Group = "reticulum";
        StateDirectory = "rngit";
        ReadOnlyPaths = [ "/var/lib/reticulum" ];
        Restart = "on-failure";
        RestartSec = 5;

        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
      };
    };
  };
}
