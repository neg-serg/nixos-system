{pkgs, ...}:
with {
  camilladsp = pkgs.callPackage ../../../../packages/camilladsp {};
}; {
  nixpkgs.overlays = [
    (self: super: {
      # audio plugin host  TODO: install gui later (github.com/HEnquist/camilladsp)
      carla = super.carla.override { python3 = super.python312; }; 
    })
  ];
  environment.systemPackages = with pkgs; [
    brutefir # one of the best FIR filters for linux
    camilladsp # one of the best DSP for linux
    jamesdsp # pipewire dsp
    lsp-plugins # various linux dsp
    yabridgectl # vst control for linux
    yabridge # vst bridge for linux
  ];
}
