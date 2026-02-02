{
  inputs,
  pkgs,
  # pkgsUnstable,
  ...
}:
let
  helixPkg = inputs.helix.packages."${pkgs.stdenv.hostPlatform.system}".default;
  # helixPkg = pkgs.helix;
  # helixPkg = pkgsUnstable.helix;

  helixConfig = ./config.toml;

  xdgDir = pkgs.linkFarm "helix-config" [
    {
      name = "helix/config.toml";
      path = helixConfig;
    }
  ];

  helixWrapped = pkgs.symlinkJoin {
    name = "hx";
    paths = [ helixPkg ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/hx --add-flags "--config ${xdgDir}/helix/config.toml"
    '';
  };
in
{
  config = {
    environment.systemPackages = [ helixWrapped ];
  };
}
