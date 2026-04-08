{
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.docker-compose ];
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
