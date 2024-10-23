{pkgs, ...}: {
  environment.systemPackages = [pkgs.flatpak pkgs.flatpak-builder];
  services.flatpak.enable = true;
  services.flatpak.packages = [
    {
      appId = "us.zoom.Zoom";
      origin = "flathub";
    }
    {
      appId = "com.obsproject.Studio";
      origin = "flathub";
    }
    {
      appId = "org.onlyoffice.desktopeditors";
      origin = "flathub";
    }
    {
      appId = "com.usebottles.bottles";
      origin = "flathub";
    }
  ];
  services.flatpak.update.onActivation = true;
}
