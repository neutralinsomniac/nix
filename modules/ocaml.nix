{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ocaml
    pkgs.opam
  ];
}
