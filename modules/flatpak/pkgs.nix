{pkgs, ...}: {
  environment.systemPackages = [pkgs.flatpak pkgs.flatpak-builder];
}
