{pkgs, ...}: {
  hardware.pulseaudio.enable = false;
  hardware.pulseaudio.support32Bit = false;
  hardware.pulseaudio.configFile = pkgs.runCommand "default.pa" {} ''
    sed 's/avoid-resampling$/avoid-resampling = true/' \
    ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
  '';
}
