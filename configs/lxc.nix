{ ... }:
{
  virtualisation.lxd.enable = true;

  users.users.jeremy.extraGroups = [ "lxd" ];
}
