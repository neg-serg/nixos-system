{pkgs, ...}: {
  environment.systemPackages = [pkgs.appimage-run];
}
