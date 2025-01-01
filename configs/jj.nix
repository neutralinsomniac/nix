{ pkgs
, pkgsUnstable
, ...
}:
let
  jjPkg = pkgsUnstable.jujutsu;

  jjConfig = pkgs.writeText "config.toml"
    ''
    [user]
    name = "Jeremy O'Brien"
    email = "neutral@fastmail.com"

    [ui]
    default-command = "log"
    diff.format = "git"

    [aliases]
    shortlog = ["log", "-n", "20"]
    up = ["rebase", "-b", "@", "-d", "trunk()"]
    a = ["log", "-r", "all()"]
    b = ["bookmark"]
    arst = ["bookmark", "move", "--from", "heads(::@- & bookmarks())", "--to", "@-"]

    [templates]
    draft_commit_description = """
    concat(
      description,
      surround(
        "\nJJ: This commit contains the following changes:\n", "",
        indent("JJ:     ", diff.stat(72)),
      ),
    )"""
  '';

  xdgDir = pkgs.linkFarm "jj-config" [
    {
      name = "jj/config.toml";
      path = jjConfig;
    }
  ];

  jjWrapped = pkgs.symlinkJoin {
    name = "jj";
    paths = [ jjPkg ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/jj \
      --set XDG_CONFIG_HOME "${xdgDir}"
    '';
  };
in
{
  config = {
    environment.systemPackages = [ jjWrapped ];
  };
}
