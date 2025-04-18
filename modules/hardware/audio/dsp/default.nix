{pkgs, stable, ...}:
with {
  camilladsp = pkgs.callPackage ../../../../packages/camilladsp {};
}; {
  environment.systemPackages = with pkgs; [
    brutefir # one of the best FIR filters for linux
    camilladsp # one of the best DSP for linux
    carla # audio plugin host  TODO: install gui later (github.com/HEnquist/camilladsp)
    stable.jamesdsp # pipewire dsp
    lsp-plugins # various linux dsp
    yabridgectl # vst control for linux
    stable.yabridge # vst bridge for linux
  ];
}
