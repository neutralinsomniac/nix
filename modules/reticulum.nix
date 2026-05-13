{
  pkgs,
  ...
}:
{
  networking.firewall.allowedUDPPorts = [
    29716
    42671
  ];

  environment.systemPackages = [
    pkgs.python3Packages.nomadnet
    pkgs.python3Packages.rns
    pkgs.adafruit-nrfutil
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "python3.13-ecdsa-0.19.1"
  ];

  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pyfinal: pyprev: {
          rns = pyprev.rns.overridePythonAttrs rec {
            version = "1.2.5";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "Reticulum";
              tag = version;
              hash = "sha256-FEpQiq6pnFGCMEGOikkf8QFRVPhlTf0X40foqCBfGpU=";
            };
          };

          lxmf = pyprev.lxmf.overridePythonAttrs rec {
            version = "0.9.6";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "lxmf";
              tag = version;
              hash = "sha256-Q84v1CkyEYpW4QdtOD6zp7bn4UzMDeS9Q8fO91BnuPA=";
            };
          };

          nomadnet = pyprev.nomadnet.overridePythonAttrs (old: rec {
            version = "1.0.1";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "NomadNet";
              tag = version;
              hash = "sha256-uNchcz9kiLX2nUNRC2rTMv7my+19ylZrHTGWbonziFc=";
            };

            dependencies = old.dependencies ++ [ pkgs.python3Packages.msgpack ];
          });
        })
      ];
    })
  ];
}
