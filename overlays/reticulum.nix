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

      lxmf = pyprev.lxmf.overridePythonAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "neutralinsomniac";
          repo = "lxmf";
          rev = "1.0.2";
          hash = "sha256-UaiB+SFbrH5xFFLTd0OQcuoS3hNIDRrXIiykOdjbA60=";
        };
      });

      nomadnet = pyprev.nomadnet.overridePythonAttrs (old: rec {
        version = "1.2.7";
        src = pyfinal.fetchPypi {
          pname = "nomadnet";
          inherit version;
          hash = "sha256-52pFpgeRBXouASwpx8vLn+ZDHx7Tl6NttkgRkENhT1s=";
        };

        dependencies = old.dependencies ++ [ pyfinal.msgpack ];
      });
    })
  ];
}
