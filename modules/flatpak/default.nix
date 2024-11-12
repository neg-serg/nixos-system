{pkgs, ...}: {
  environment.systemPackages = [pkgs.flatpak pkgs.flatpak-builder];
  services.flatpak = {
    enable = true;
    packages = [
      {
        appId = "com.obsproject.Studio";
        origin = "flathub";
      }
      {
        appId = "org.onlyoffice.desktopeditors";
        origin = "flathub";
      }
      {
        appId = "im.riot.Riot";
        origin = "flathub";
      }
    ];
    update.onActivation = true;
  };
}
