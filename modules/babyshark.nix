{ pkgs, lib, ... }:
let
  babyshark = pkgs.rustPlatform.buildRustPackage rec {
    name = "babyshark";

    src = pkgs.fetchFromGitHub {
      owner = "vignesh07";
      repo = "babyshark";
      rev = "a26726100761b7b95775101c1f974d38d069d7fa";
      hash = "sha256-E7npj/yUIPC//s4et0zBqSvQhooW3uLdnVZW8Mg6z4I=";
    };

    cargoLock.lockFile = "${src}/rust/Cargo.lock";

    sourceRoot = "source/rust";

    meta = {
      description = "A remote file/directory transfer tool with a simple interface";
      homepage = "https://github.com/neutralinsomniac/raptorboost";
      license = lib.licenses.mit;
      maintainers = [ ];
    };
  };
in
{
  environment.systemPackages = [ babyshark ];
}
