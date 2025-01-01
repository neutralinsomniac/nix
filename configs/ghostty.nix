{ inputs
, pkgs
, ...
}:
let
  ghosttyPkg = inputs.ghostty.packages.x86_64-linux.default;

  ghosttyConfig = pkgs.writeText "config" ''
    gtk-single-instance = true
    theme = carbonfox
  '';

  xdgDir = pkgs.linkFarm "ghostty-config" [
    {
      name = "ghostty/config";
      path = ghosttyConfig;
    }
  ];

  ghosttyWrapped = pkgs.symlinkJoin {
    name = "ghostty";
    paths = [ ghosttyPkg ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/ghostty \
      --set XDG_CONFIG_HOME "${xdgDir}"
      '';
  };
in
{
  config = {
    environment.systemPackages = [ ghosttyWrapped ];
  };
}
