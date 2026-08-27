final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyfinal: pyprev: {
      rns = pyprev.rns.overridePythonAttrs rec {
        version = "1.5.0";
        src = pyfinal.fetchPypi {
          pname = "rns";
          inherit version;
          hash = "sha256-bH3tTnj/bxMoFN4cTgMtiEoXZGoiLpi8qA2Ni8YsVIY=";
        };
      };

      lxmf = pyprev.lxmf.overridePythonAttrs (old: rec {
        version = "1.1.1";
        src = final.fetchPypi {
          pname = "lxmf";
          inherit version;
          hash = "sha256-8vfqF9eT/MMsq4JugejpgkQE0CXR/HGxQ74yQtReal4=";
        };
      });

      nomadnet = pyprev.nomadnet.overridePythonAttrs (old: rec {
        version = "1.2.8";
        src = pyfinal.fetchPypi {
          pname = "nomadnet";
          inherit version;
          hash = "sha256-6RQsbUIruRc2r+br62GArjRQTst7xrR5R1YFVvjroeE=";
        };
      });
    })
  ];
}
