{
  ...
}:
{
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["jeremy"];
  virtualisation.libvirtd.enable = true;
}
