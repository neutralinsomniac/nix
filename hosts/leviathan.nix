{ inputs, ... }:
let inherit (import ./_lib.nix inputs) mkHost; in
{
  flake.nixosConfigurations.leviathan = mkHost {
    name = "leviathan";
    extraModules = [
      inputs.nixos-hardware.nixosModules.asus-flow-gv302x-amdgpu
      (inputs.self + "/hw/leviathan/disk-config.nix")
      (
        { pkgs, ... }:
        {
          boot.kernelPackages = pkgs.linuxPackages_latest;
          hardware.asus.flow.gv302x.amdgpu.psr.enable = false;
          boot.kernelParams = [ "amdgpu.dcdebugmask=0x600" ];
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
