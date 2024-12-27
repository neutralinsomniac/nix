{ pkgs
, inputs
, pkgsUnstable
, ...
}:
let
  tomlFmt = pkgs.formats.toml { };
  jjPkg = pkgsUnstable.jujutsu;
  jjBin = "${jjPkg}/bin/jj";

  jjConfig = tomlFmt.generate "config.toml" {
    user = {
      name = "Jeremy O'Brien";
      email = "neutral@fastmail.com";
    };
    ui = {
      default-command = "log";
      diff.format = "git";
      pager = ":builtin";
      paginate = "never";
      editor = "vim";
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

  xdgDir = pkgs.linkFarm "jj-config" [
    {
      name = "jj/config.toml";
      path = jjConfig;
    }
  ];
  jjScript = pkgs.writeScriptBin "jj" ''
  # Conf:  ${jjConfig}

  env XDG_CONFIG_HOME="${xdgDir}" ${jjBin} "$@"
'';
in
{
  config = {
    environment.systemPackages = [ jjScript ];
  };
}
