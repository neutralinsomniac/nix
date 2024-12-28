{ ... }: {
  programs.firefox = {
    enable = true;
    preferences = {
      "browser.backspace_action" = 0;
      "browser.startup.page" = 3; # restore previous session
    };
    policies = {
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisablePocket = true;
      DisableTelemetry = true;
      EnableTrackingProtection = {
        Fingerprinting = true;
        Cryptomining = true;
        EmailTracking = true;
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };
      FirefoxHome = {
        Search = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = false;
        MoreFromMozilla = false;
      };
    };
  };
}
