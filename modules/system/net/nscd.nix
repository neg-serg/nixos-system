{pkgs, ...}: {
  services.nscd.enableNsncd = false; # try to fix buggy nscd
  services.nscd.package = pkgs.unscd;
}
