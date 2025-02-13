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

    [git]
    subprocess = true

    [aliases]
    shortlog = ["log", "-n", "20"]
    up = ["rebase", "-b", "@", "-d", "trunk()"]
    a = ["log", "-r", "all()"]
    arst = ["bookmark", "move", "--from", "heads(::@- & bookmarks())", "--to", "@-"]
    flat = ["log", "--no-graph", "-T", "builtin_log_oneline"]

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
      --set JJ_CONFIG "${xdgDir}/jj/"
    '';
  };
in
{
  config = {
    environment.systemPackages = [ jjWrapped ];
  };
}
