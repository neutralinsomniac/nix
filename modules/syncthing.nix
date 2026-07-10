{
  services.syncthing = {
    enable = true;
    user = "jeremy";
    dataDir = "/home/jeremy/Sync";
    configDir = "/home/jeremy/.config/syncthing";
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
  };
}
