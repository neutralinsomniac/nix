{ pkgs, lib, inputs, ... }:
let
  firmware = pkgs.fetchzip {
    url = "https://pintobyte.com/tmp/m1-firmware.tgz";
    hash = "sha256-wr1YWNJ8c3A4s8fXDNlhvjjq9r8Grkj2c17eX/gblJo=";
  };
in
{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
    ./hardware-configuration.nix
  ];

  config = {
    nix.settings = {
      extra-substituters = [
        "https://nixos-apple-silicon.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
      ];
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;

    boot.extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';

    hardware.asahi.peripheralFirmwareDirectory = firmware;

    system.stateVersion = lib.mkForce "25.11";
  };
}
