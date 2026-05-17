final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyfinal: pyprev: {
      rns = pyprev.rns.overridePythonAttrs rec {
        version = "1.2.7";

        src = final.fetchFromGitHub {
          owner = "markqvist";
          repo = "Reticulum";
          tag = version;
          hash = "sha256-Z4rAmprGj7MYkFHpaNwcMysjeSkLrqm115LzaNlI8I4=";
        };
      };

      lxmf = pyprev.lxmf.overridePythonAttrs rec {
        version = "0.9.8";

        src = final.fetchFromGitHub {
          owner = "markqvist";
          repo = "lxmf";
          tag = version;
          hash = "sha256-26T8f4WCf5q5/2RKA2Dh5xxqUOR3XXRFOzezCuDRA6c=";
        };
      };

      nomadnet = pyprev.nomadnet.overridePythonAttrs (old: rec {
        version = "1.1.0";

        src = final.fetchFromGitHub {
          owner = "markqvist";
          repo = "NomadNet";
          tag = version;
          hash = "sha256-2XbEJfB9Qj58u3rdTQA4DY2ZsVk/6FBhvlggBdrwRBk=";
        };

        dependencies = old.dependencies ++ [ pyfinal.msgpack ];
      });
    })
  ];
}
