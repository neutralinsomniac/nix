{
  programs.git = {
    enable = true;
    config = [
      {
        user = {
          name = "Jeremy O'Brien";
          email = "neutral@fastmail.com";
        };
      }

      { push = { default = "current"; }; }
    ];
  };
}
