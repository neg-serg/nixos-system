{...}: {
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      MusicFolder = "/one/music";
    };
  };
}
