{
pkgs
# , inputs
# , pkgsUnstable
, ...
}:
let
  jjPkg = pkgs.jujutsu;
  # jjPkg = pkgsUnstable.jujutsu;
  # jjPkg = inputs.jujutsu.packages.x86_64-linux.default;

  jjConfig = pkgs.writeText "config.toml"
    ''
    [user]
    name = "Jeremy O'Brien"
    email = "neutral@fastmail.com"

    [ui]
    bookmark-list-sort-keys = ["committer-date-"]
    default-command = "log"
    diff-formatter = ":git"

    [revset-aliases]
    'closest_bookmark(to)' = 'heads(::to & bookmarks())'
    'unmerged(from)' = '::from ~ ::trunk()'

    [aliases]
    shortlog = ["log", "-n", "20"]
    up = ["rebase", "-b", "@", "-d", "trunk()"]
    a = ["log", "-r", "all()"]
    tug = ["bookmark", "move", "--from", "closest_bookmark(@-)", "--to", "@-"]
    flat = ["log", "--no-graph", "-T", "builtin_log_oneline"]
    ra = ["rebase", "-b", "all:author('neutral@fastmail.com') & mutable() & heads(::)", "-d", "trunk()"]
    fa = ["git", "fetch", "--all-remotes"]
    incoming = ["log", "-r", "@..trunk()"]
    pn = ["git", "push", "--allow-new"]

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
