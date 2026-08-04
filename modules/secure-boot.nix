{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options = {
    useSecureBoot = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf (config.useSecureBoot == true) {
    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    # fwupd >= 2.1 ignores the FWUPD_EFIAPPDIR environment variable that
    # lanzaboote v1.0.0 sets, breaking EFI updates. Bake the /run/fwupd-efi
    # location (where lanzaboote puts the signed EFI app) into fwupd instead.
    # Equivalent of https://github.com/nix-community/lanzaboote/pull/640,
    # adapted for fwupd 2.1.4 where efi_app_location is not yet a meson
    # option — remove once the fix lands in a lanzaboote release we pin.
    services.fwupd.package = pkgs.fwupd.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace meson.build \
          --replace-fail "efi_app_location = join_paths(dependency('fwupd-efi').get_variable(pkgconfig: 'prefix'), 'libexec', 'fwupd', 'efi')" \
                         "efi_app_location = '/run/fwupd-efi'"
      '';
    });
    systemd.services.fwupd.environment.FWUPD_EFIAPPDIR = lib.mkForce null;
  };
}
