final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyfinal: pyprev: {
      rns = pyprev.rns.overridePythonAttrs rec {
        version = "1.4.0";
        src = pyfinal.fetchPypi {
          pname = "rns";
          inherit version;
          hash = "sha256-+p520KeL8lPq5mE35rvcZfRw2zlQqVsDTOMsqEX/DkQ=";
        };
      };

      lxmf = pyprev.lxmf.overridePythonAttrs (old: rec {
        version = "1.1.0";
        src = final.fetchPypi {
          pname = "lxmf";
          inherit version;
          hash = "sha256-GH5cuiVxY7oc/6G0mjPciJPPO5gjl8zXdGHOqlzVSvE=";
        };
      });

      nomadnet = pyprev.nomadnet.overridePythonAttrs (old: rec {
        version = "1.2.7";
        src = pyfinal.fetchPypi {
          pname = "nomadnet";
          inherit version;
          hash = "sha256-52pFpgeRBXouASwpx8vLn+ZDHx7Tl6NttkgRkENhT1s=";
        };
      });
    })
  ];
}
