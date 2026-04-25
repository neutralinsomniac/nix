{
  pkgs,
  ...
}:
let
  micasa = pkgs.buildGoModule rec {
    name = "micasa";
    version = "1.37.1";

    src = pkgs.fetchFromGitHub {
      owner = "cpcloud";
      repo = "micasa";
      tag = "v${version}";
      hash = "sha256-Pwz67eH4F0CIgfQUN3uQhZDhNAHdeEEpNbzTKyxVHXI=";
    };

    vendorHash = "sha256-FZfMwtcVOZ8mkA1NHXitqwp5X/FTb1VxyKvoy5qEoPU=";

    doCheck = false;
  };
in
{
  environment.systemPackages = [ micasa ];
}
