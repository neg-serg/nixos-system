{pkgs, ...}: {
  fonts.fontDir.enable = true; # add fontdir support for nixos
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
    liberation_ttf # Liberation Fonts, replacements for Times New Roman, Arial, and Courier New
    symbola # Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode
    texlivePackages.opensans # The Open Sans font family, and LaTeX support
  ];
}
