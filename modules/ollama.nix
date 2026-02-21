{ pkgs, lib, ... }:
{
  options = {
    enableOllama = lib.mkOption {
      type = lib.types.bool;
    };
  };

  config = {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
    };
  };
}
