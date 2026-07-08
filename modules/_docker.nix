{
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.docker-compose ];
  users.users.jeremy.extraGroups = [ "docker" ];
  virtualisation.docker.enable = true;
}
