{
  programs.git = {
    enable = true;
    config = [
      {
        gpg = {
          format = "ssh";
          ssh.program = "rngcs";
          ssh.allowedsignersfile = "none";
        };
      }
      {
        user = {
          name = "Jeremy O'Brien";
          email = "neutral@fastmail.com";
          signingKey = "~/.rngit/client_identity";
        };
      }

      {
        push = {
          default = "current";
        };
      }
    ];
  };
}
