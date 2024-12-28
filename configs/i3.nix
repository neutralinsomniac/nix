{ pkgs
, inputs
, pkgsUnstable
, ...
}:
let
  tomlFmt = pkgs.formats.toml { };
  i3Pkg = pkgsUnstable.jujutsu;
  i3Bin = "${i3Pkg}/bin/i3";

  i3Config = tomlFmt.generate "config" {
    user = {
      name = "Jeremy O'Brien";
      email = "neutral@fastmail.com";
    };
    ui = {
      default-command = "log";
      diff.format = "git";
      pager = ":builtin";
      paginate = "never";
    };
    templates.draft_commit_description = ''
      concat(
        description,
        surround(
          "\nJJ: This commit contains the following changes:\n", "",
          indent("JJ:     ", diff.stat(72)),
        ),
      )
    '';
  };

  xdgDir = pkgs.linkFarm "i3-config" [
    {
      name = "i3/config.toml";
      path = i3Config;
    }
  ];
  i3Script = pkgs.writeScriptBin "i3" ''
    #!/usr/bin/env bash
    # Conf:  ${i3Config}

    env XDG_CONFIG_HOME="${xdgDir}" ${i3Bin} "$@"
  '';
in
{
  config = {
    environment.systemPackages = [ i3Script ];
  };
}
