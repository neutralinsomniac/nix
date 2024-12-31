{ inputs
, pkgs
, ...
}:
let
  helixPkg = inputs.helix.packages.x86_64-linux.default;

  tomlFmt = pkgs.formats.toml { };

  helixConfig = tomlFmt.generate "config.toml" {
    theme = "carbonfox";
    editor = {
      bufferline = "multiple";
      line-number = "relative";
      soft-wrap.enable = true;
      idle-timeout = 0;
      whitespace.render.newline = "all";
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      inline-diagnostics = {
        cursor-line = "hint";
        other-lines = "error";
      };
    };
    keys = {
      normal = {
       "space".F = "file_picker_in_current_directory";
        left = ":buffer-previous";
        right = ":buffer-next";
      };
    };
  };

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
      wrapProgram $out/bin/hx \
      --set XDG_CONFIG_HOME "${xdgDir}"
      '';
  };
in
{
  config = {
    environment.systemPackages = [ helixWrapped ];
  };
}
