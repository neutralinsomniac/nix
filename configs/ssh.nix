{ pkgs
, pkgsUnstable
, ...
}:
let
  sshPkg = pkgs.openssh;

  sshConfig = pkgs.writeText "config" ''
    Host pintobyte.com
    Port 2345
  '';

  sshWrapped = pkgs.symlinkJoin {
    name = "ssh";
    paths = [ sshPkg ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/ssh \
      --add-flags "-F ${sshConfig}"
    '';
  };
in
{
  config = {
    environment.systemPackages = [ sshWrapped ];
  };
}
