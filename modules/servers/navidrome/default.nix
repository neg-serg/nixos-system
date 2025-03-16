{...}: {
  services.navidrome = {
    enable = false;
    openFirewall = false;
    settings = {
      MusicFolder = "/one/music";
    };
  };
}
