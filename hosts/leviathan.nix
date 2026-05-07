{ lib, inputs, ... }:
{
  flake.nixosConfigurations.leviathan = lib.mkHost {
    name = "leviathan";
    myHidpiScale = 1.75;
    extraModules = [
      inputs.nixos-hardware.nixosModules.asus-flow-gv302x-amdgpu
      (inputs.self + "/hw/leviathan/disk-config.nix")
      (
        { pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_latest;
          boot.kernelParams = lib.mkAfter [ "amdgpu.dcdebugmask=0x410" ];
          # we only have one graphics card; no need for this
          services.supergfxd.enable = false;
          # this driver is buggy as heck # maybe not on 6.17?
          # boot.blacklistedKernelModules = [ "hid_asus" ];
          hardware.bluetooth.enable = true;
        }
      )
    ];
  };
}
