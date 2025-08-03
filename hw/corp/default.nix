{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  config = {
  };
}
