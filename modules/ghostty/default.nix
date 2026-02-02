{
  inputs,
  pkgs,
  ...
}:
let
  # ghosttyPkg = inputs.ghostty-mjrochford.packages.x86_64-linux.default;
  ghosttyPkg = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # ghosttyPkg = pkgs.ghostty;

  ghosttyConfig = ./config;

  ghosttyWrapped = pkgs.symlinkJoin {
    name = "ghostty";
    paths = [ ghosttyPkg ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/ghostty --add-flags "--config-file=${ghosttyConfig}"
    '';
  };
in
{
  config = {
    environment.systemPackages = [ ghosttyWrapped ];
  };
}
