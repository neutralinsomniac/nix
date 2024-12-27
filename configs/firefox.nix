{
  # firefox.
  programs.firefox = {
    enable = true;
    preferences = {
      "browser.backspace_action" = 0;
      "browser.startup.page" = 3; # restore previous session
    };
  };
}
