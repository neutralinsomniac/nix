{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lxmd;
in
{
  # lxmd depends on the rnsd module for the shared Reticulum instance;
  # the module system dedupes this with the auto-import in default.nix
  imports = [ ./rnsd.nix ];

  options.services.lxmd = {
    enable = lib.mkEnableOption "lxmd, the LXMF message router daemon";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.python3Packages.lxmf;
      defaultText = lib.literalExpression "pkgs.python3Packages.lxmf";
      description = "lxmf package providing the lxmd binary.";
    };

    propagationNode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run an LXMF propagation node.";
    };

    settings = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = ''
        Contents of the lxmd config file. When null, lxmd writes a
        default config to /var/lib/lxmd/config on first start, which
        can then be edited in place.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.rnsd.enable;
        message = "services.lxmd requires services.rnsd for the shared Reticulum instance";
      }
    ];

    # lxmd's ReadWritePaths needs this to exist at sandbox setup, which can
    # race rnsd creating it on a fresh host
    systemd.tmpfiles.rules = [ "d /var/lib/reticulum/storage 0750 reticulum reticulum -" ];

    systemd.services.lxmd = {
      description = "LXMF message router daemon";
      requires = [ "rnsd.service" ];
      after = [ "rnsd.service" ];
      wantedBy = [ "multi-user.target" ];

      preStart = lib.optionalString (cfg.settings != null) ''
        ln -sf ${pkgs.writeText "lxmd-config" cfg.settings} /var/lib/lxmd/config
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/lxmd --config /var/lib/lxmd --rnsconfig /var/lib/reticulum${lib.optionalString cfg.propagationNode " --propagation-node"}";
        User = "reticulum";
        Group = "reticulum";
        StateDirectory = "lxmd";
        ReadWritePaths = [ "/var/lib/reticulum/storage" ];
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
