{
  pkgs,
  ...
}:
{
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
  ];
  environment.systemPackages = [ pkgs.openra ];
}
