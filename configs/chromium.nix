{ ... }:
{
  programs.chromium = {
    enable = true;
    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "en-US"
      ];
      "RestoreOnStartup" = 1; # open last session
    };
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "nlffgllnjjkheddehpolbanogdeaogbc" # backspace to go back
      "fnaicdffflnofjppbagibeoednhnbjhg" # floccus
    ];
  };
}
