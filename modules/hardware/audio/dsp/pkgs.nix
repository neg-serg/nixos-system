{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    brutefir # FIR filter
    camilladsp # flexible audio DSP
    jamesdsp # PipeWire DSP
    lsp-plugins # various audio plugins
    yabridgectl # VST management on Linux
    yabridge # VST bridge for Linux
  ];
}
