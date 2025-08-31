{pkgs, ...}: {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 128;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
    };
    wireplumber = {
      package = pkgs.wireplumber;
      extraConfig = {
        # # Tell wireplumber to be more verbose
        # "10-log-level-debug" = {
        #   "context.properties"."log.level" = "D"; # output debug logs
        # };
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
