{ pkgs
, pkgsUnstable
, ...
}:
let
  # helixPkg = inputs.helix.packages.x86_64-linux.default;
  helixPkg = pkgsUnstable.helix;

  helixConfig = pkgs.writeText "config.toml" ''
    # theme = "carbonfox"
    theme = "acme"

    [editor]
    bufferline = "multiple"
    idle-timeout = 0
    line-number = "relative"

    [editor.cursor-shape]
    insert = "bar"
    normal = "block"
    select = "underline"

    [editor.inline-diagnostics]
    cursor-line = "hint"
    other-lines = "error"

    [editor.soft-wrap]
    enable = true

    [editor.whitespace.render]
    newline = "all"

    [keys.normal]
    left = ":buffer-previous"
    right = ":buffer-next"

    [keys.normal.space]
    F = "file_picker_in_current_directory"
  '';

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
      --add-flags "--config ${xdgDir}/helix/config.toml"
    '';
  };
in
{
  config = {
    environment.systemPackages = [ helixWrapped ];
  };
}
