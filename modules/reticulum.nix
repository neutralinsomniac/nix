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
            version = "1.1.3";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "Reticulum";
              tag = version;
              hash = "sha256-Iz/1mSCww/v6wsRTG5j55IRTOjQ6y2eOlBda/CcwsOE=";
            };
          };

          lxmf = pyprev.lxmf.overridePythonAttrs {
            version = "0.9.4";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "lxmf";
              rev = "72853fcf77b1653dcfb33d83390b4539fd71178e";
              hash = "sha256-QVz0w1FNQ5tAH8ANmmE1Q2nW9WTRIwDvqRa+vuze31k=";
            };
          };

          nomadnet = pyprev.nomadnet.overridePythonAttrs (old: {
            version = "0.9.9";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "NomadNet";
              rev = "c7e473452ae6d142e22f3c5cbafd12a481cacc82";
              hash = "sha256-qLe9fnIE9kY9JerAAH318dq1SOshP9xX3l/2c91fnSA=";
            };

            dependencies = old.dependencies ++ [ pkgs.python3Packages.msgpack ];
          });
        })
      ];
    })
  ];
}
