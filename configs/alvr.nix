{
  pkgs,
  ...
}:
{
  programs.alvr = {
    enable = true;
    package = pkgs.alvr.overrideAttrs (
      finalAttrs: previousAttrs: {
        patches = previousAttrs.patches ++ [ ./395fix.diff ];
      }
    );
    openFirewall = true;
  };
}
