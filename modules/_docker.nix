{
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.docker-compose ];
  users.users.jeremy.extraGroups = [ "docker" ];
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
