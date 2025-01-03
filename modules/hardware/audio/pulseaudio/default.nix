{pkgs, ...}: {
  services.pulseaudio.enable = false;
  services.pulseaudio.support32Bit = false;
  services.pulseaudio.configFile = pkgs.runCommand "default.pa" {} ''
    sed 's/avoid-resampling$/avoid-resampling = true/' \
    ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
  '';
}
