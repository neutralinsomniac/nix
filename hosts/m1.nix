{ lib, inputs, ... }:
{
  flake.nixosConfigurations.m1 = lib.mkHost {
    name = "m1";
    system = "aarch64-linux";
    nixpkgs = inputs.nixos-apple-silicon.inputs.nixpkgs;
    extraModules = [
      inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
      (
        { pkgs, lib, ... }:
        let
          firmware = pkgs.fetchzip {
            url = "https://pintobyte.com/tmp/m1-firmware.tgz";
            hash = "sha256-xmVfPwFfwASWEHqRbzBW81r3Gy+zAxMHASR6yu76Wfo=";
          };
        in
        {
          nix.settings = {
            extra-substituters = [ "https://nixos-apple-silicon.cachix.org" ];
            extra-trusted-public-keys = [
              "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
            ];
          };
          hardware.asahi.enable = true;
          environment.systemPackages = with pkgs; [ ncspot ];
          zramSwap.enable = true;
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = false;
          boot.extraModprobeConfig = ''
            options hid_apple iso_layout=0
          '';
          hardware.asahi.peripheralFirmwareDirectory = firmware;
          system.stateVersion = lib.mkForce "25.11";
        }
      )
    ];
  };
}
