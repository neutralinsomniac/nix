final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyfinal: pyprev: {
      rns = pyprev.rns.overridePythonAttrs rec {
        version = "1.3.7";
        src = pyfinal.fetchPypi {
          pname = "rns";
          inherit version;
          hash = "sha256-Z1fbZcCvISs4a35EuV7aTjbWsRyug0JYvG0tEdrG4SU=";
        };
      };

      lxmf = pyprev.lxmf.overridePythonAttrs rec {
        version = "1.0.1";
        src = pyfinal.fetchPypi {
          pname = "lxmf";
          inherit version;
          hash = "sha256-0S6tRIKWy9CSA0YtjclqJutx7xaLQZexM6lw1IOmB+o=";
        };
      };

      nomadnet = pyprev.nomadnet.overridePythonAttrs (old: rec {
        version = "1.2.6";
        src = pyfinal.fetchPypi {
          pname = "nomadnet";
          inherit version;
          hash = "sha256-XNRs4avq22JslxkSlqgTOj0bKuiVwam3i9bzoMAUjAU=";
        };

        dependencies = old.dependencies ++ [ pyfinal.msgpack ];
      });
    })
  ];
}
