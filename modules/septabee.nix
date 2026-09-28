{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.septabee.nixosModules.default ];

  config = {
    programs.septabee = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
      enable = true;
      wayland-deps = true; # Install wayland only dependencies
      version = "latest"; # like [ "latest" "B_T1" "B_T2" ... ]
      offline = true; # Doesn't require downloading LLVM stuff
    };
  };
}
