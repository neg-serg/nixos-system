{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    jamesdsp # pipewire dsp
    carla # audio plugin host
    lsp-plugins # various linux dsp
  ];
}
