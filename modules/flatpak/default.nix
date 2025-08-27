{pkgs, ...}: {
  environment.systemPackages = [pkgs.flatpak pkgs.flatpak-builder];
  services.flatpak = {
    enable = true;

    overrides = {
      global = {
        Environment = {
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons"; # Fix un-themed cursor in some Wayland apps
          GTK_THEME = "Adwaita:dark"; # Force correct theme for some GTK apps
        };
      };
      # "im.riot.Riot".Context = {
      #   filesystems = ["/run/current-system/sw/bin:ro" "/home/neg/dw/:rw" "/home/neg/pic/:rw"];
      # };
    };

    packages = [
      {
        appId = "com.obsproject.Studio";
        origin = "flathub";
      }
      {
        appId = "com.wps.Office";
        origin = "flathub";
      }
      {
        appId = "md.obsidian.Obsidian";
        origin = "flathub";
      }
      {
        appId = "org.zealdocs.Zeal";
        origin = "flathub";
      }
      {
        appId = "org.chromium.Chromium";
        origin = "flathub";
      }
    ];
    update.onActivation = false;
  };
}
