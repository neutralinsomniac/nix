{
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
  ];
}
