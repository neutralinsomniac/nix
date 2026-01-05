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
  ];

  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pyfinal: pyprev: {
          rns = pyfinal.callPackage pyprev.rns.overridePythonAttrs rec {
            version = "1.1.0";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "Reticulum";
              tag = version;
              hash = "sha256-aoKiTdv5r3Z20D6znFLVf/8C4WpDBjKKnaYJQ8zaGVI=";
            };
          };

          lxmf = pyfinal.callPackage pyprev.lxmf.overridePythonAttrs {
            version = "0.9.4";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "lxmf";
              rev = "72853fcf77b1653dcfb33d83390b4539fd71178e";
              hash = "sha256-QVz0w1FNQ5tAH8ANmmE1Q2nW9WTRIwDvqRa+vuze31k=";
            };
          };

          nomadnet = pyfinal.callPackage pyprev.nomadnet.overridePythonAttrs {
            version = "0.9.7";

            src = pkgs.fetchFromGitHub {
              owner = "markqvist";
              repo = "NomadNet";
              rev = "70baa59ac2913cb0007862d76b75e086bfa51f7b";
              hash = "sha256-lvGladjiQaX0y2X3ttZ3DDxPOLGN2Ru5j/UmrzOxwbU=";
            };
          };
        })
      ];
    })
  ];
}
