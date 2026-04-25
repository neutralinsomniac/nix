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
            version = "1.1.9";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "Reticulum";
              tag = version;
              hash = "sha256-JYBXk/IOL+XVhvF1qEs/1H9VMWbfLQmIPrLJgJv2ZBw=";
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
            version = "0.9.11";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "NomadNet";
              tag = version;
              hash = "sha256-vIV3FEvwqd2je/DzGWeshEx5Tb+DhOQIg7l0LbffEwY=";
            };

            dependencies = old.dependencies ++ [ pkgs.python3Packages.msgpack ];
          });
        })
      ];
    })
  ];
}
