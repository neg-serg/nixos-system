{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    brutefir # one of the best FIR filters for linux
    carla # audio plugin host
    jamesdsp # pipewire dsp
    lsp-plugins # various linux dsp
    yabridgectl # vst control for linux
    yabridge # vst for linux
  ];
}
