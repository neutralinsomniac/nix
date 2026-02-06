{
  pkgs,
  ...
}:
let
  sshPkg = pkgs.openssh;

  sshConfig = ./config;

  sshWrapped = pkgs.symlinkJoin {
    name = "ssh";
    paths = [ sshPkg ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/ssh --add-flags "-F ${sshConfig}"
      wrapProgram $out/bin/scp  --add-flags "-F ${sshConfig}"
    '';
  };
in
{
  config = {
    environment.systemPackages = [ sshWrapped ];
  };
}
