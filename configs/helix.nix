{ pkgs
, ...
}:
let
  tomlFmt = pkgs.formats.toml { };
  helixBin = "${pkgs.helix}/bin/hx";

  helixConfig = tomlFmt.generate "config.toml" {
    theme = "acme";
    editor = {
      mouse = true;
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
    };
  };

  xdgDir = pkgs.linkFarm "helix-config" [
    {
      name = "helix/config.toml";
      path = helixConfig;
    }
  ];
  hxScript = pkgs.writeScriptBin "hx" ''
  # Conf:  ${helixConfig}

  env XDG_CONFIG_HOME="${xdgDir}" ${helixBin} "$@"
'';
in
{
  config = {
    environment.systemPackages = [ hxScript ];
  };
}
