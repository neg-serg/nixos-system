{pkgs, ...}: {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.package = pkgs.wireplumber;
  };
  # run pipewire on default.target, this fixes xdg-portal startup delay
  systemd.user.services.pipewire.wantedBy = [ "default.target" ];
}
