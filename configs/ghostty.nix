{ inputs
, pkgs
, ...
}:
let
  ghosttyPkg = inputs.ghostty-mjrochford.packages.x86_64-linux.default;
  # ghosttyPkg = inputs.ghostty.packages.x86_64-linux.default;
  # ghosttyPkg = pkgs.ghostty;

  ghosttyConfig = pkgs.writeText "config" ''
    gtk-single-instance = true
    theme = carbonfox
    font-family = 0xProto
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
      --prefix XDG_CONFIG_DIRS : "${xdgDir}"
      '';
  };
in
{
  config = {
    environment.systemPackages = [ ghosttyWrapped ];
  };
}
