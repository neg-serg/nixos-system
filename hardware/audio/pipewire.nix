{...}: {
  nixpkgs.overlays = [
    (final: prev: {
      pipewire = prev.pipewire.override {
        stdenv = prev.stdenvAdapters.impureUseNativeOptimizations prev.gcc13Stdenv;
      };
    })
  ];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
