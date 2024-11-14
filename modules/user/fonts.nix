{pkgs, ...}: {
  fonts.fontDir.enable = true; # add fontdir support for nixos
  fonts.packages = with pkgs; [
    liberation_ttf # Liberation Fonts, replacements for Times New Roman, Arial, and Courier New
    (nerdfonts.override {fonts = ["FiraCode"];})
    proggyfonts # yet another fonts for coding
    symbola # Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode
    texlivePackages.opensans # The Open Sans font family, and LaTeX support
  ];
}
