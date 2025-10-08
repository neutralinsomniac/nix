for link in $(find /nix/var/nix/gcroots/ -type l -readable)
do
  res="${res}
$(readlink "${link}") $(nix path-info -Sh "${link}")"
done
echo "$res" | sort -h -k3,3
