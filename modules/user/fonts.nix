{pkgs, ...}: {
  fonts.fontDir.enable = true; # add fontdir support for nixos
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
  ];
}
