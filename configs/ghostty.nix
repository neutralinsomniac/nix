{ inputs
, pkgs
, ...
}:
let
  ghosttyPkg = inputs.ghostty.packages.x86_64-linux.default;
  ghosttyBin = "${ghosttyPkg}/bin/ghostty";

  ghosttyConfig = pkgs.writeText "config" ''
  gtk-single-instance = true
  '';

  xdgDir = pkgs.linkFarm "ghostty-config" [
    {
      name = "ghostty/config";
      path = ghosttyConfig;
    }
  ];

  ghosttyScript = pkgs.writeScriptBin "ghostty" ''
    #!/usr/bin/env bash
    # Conf:  ${ghosttyConfig}

    env XDG_CONFIG_HOME="${xdgDir}" ${ghosttyBin} "$@"
  '';
in
{
  config = {
    environment.systemPackages = [ ghosttyScript ];
  };
}
