{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    brutefir # one of the best FIR filters for linux
    camilladsp # one of the best DSP for linux
    jamesdsp # pipewire dsp
    lsp-plugins # various linux dsp
    yabridgectl # vst control for linux
    yabridge # vst bridge for linux
  ];
}
