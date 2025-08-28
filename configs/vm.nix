{
  ...
}:
{
  virtualisation.vmVariant = {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    virtualisation.diskSize = 40960; # 40GB
    virtualisation.memorySize = 8192; # 8GB

    # virtualisation.useNixStoreImage = true;

    virtualisation.forwardPorts = [
      { from = "host"; host.port = 2222; guest.port = 22; }
    ];

    virtualisation.qemu.options = [
      "-nographic"
    ];
  };
}
