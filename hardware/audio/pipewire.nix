{pkgs, ...}: {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      package = pkgs.wireplumber;
      extraConfig = {
        # Tell wireplumber to be more verbose
        "10-log-level-debug" = {
          "context.properties"."log.level" = "D"; # output debug logs
        };
        # Default volume is by default set to 0.4 instead set it to 1.0
        "10-default-volume" = {
          "wireplumber.settings"."device.routes.default-sink-volume" = 1.0;
        };
      };
    };
  };

  # run pipewire on default.target, this fixes xdg-portal startup delay
  systemd.user.services.pipewire.wantedBy = ["default.target"];
}
