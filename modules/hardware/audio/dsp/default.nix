{pkgs, ...}:
with {
  camilladsp = pkgs.callPackage ../../../../packages/camilladsp {};
}; {
  environment.systemPackages = with pkgs; [
    brutefir # one of the best FIR filters for linux
    # camilladsp # one of the best DSP for linux
    # TODO: install gui later (github.com/HEnquist/camilladsp)
    carla # audio plugin host
    jamesdsp # pipewire dsp
    lsp-plugins # various linux dsp
    yabridgectl # vst control for linux
    yabridge # vst for linux
  ];
}
