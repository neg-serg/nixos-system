{pkgs, ...}: {
  environment.systemPackages = [pkgs.flatpak];
  services.flatpak.enable = true;
  services.flatpak.packages = [ { appId = "us.zoom.Zoom"; origin = "flathub";  } ];
  services.flatpak.update.onActivation = true;
}
