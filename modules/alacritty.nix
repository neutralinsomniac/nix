{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "alacritty";
      paths = [ pkgs.alacritty ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/alacritty \
          --add-flags "--config-file /etc/alacritty/alacritty.toml"
      '';
    })
  ];

  environment.etc."alacritty/alacritty.toml".text = ''
    [font]
    size = 12

    [font.normal]
    family = "Hack"
    style = "Regular"
  '';
}
