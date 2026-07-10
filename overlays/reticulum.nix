final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyfinal: pyprev: {
      rns = pyprev.rns.overridePythonAttrs rec {
        version = "1.3.8";
        src = pyfinal.fetchPypi {
          pname = "rns";
          inherit version;
          hash = "sha256-1cHzlJOqm3WrZ7g5l9StW9NX5n6dYp/6KU4xov/eNH0=";
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
