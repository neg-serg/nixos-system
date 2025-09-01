{
  pkgs,
  inputs,
  ...
}: {
  # Wayland/Hyprland tools and small utilities
  environment.systemPackages = with pkgs; [
    inputs.raise.defaultPackage.${pkgs.stdenv.hostPlatform.system} # run-or-raise for Hyprland
    xorg.xeyes # track eyes for your cursor
    swaybg # simple wallpaper setter
    grimblast # Hyprland-friendly screenshots (grim+slurp+wl-copy)
    wl-clipboard # wl-copy / wl-paste
    swappy # screenshot editor (optional)
    hyprpicker # color picker for Wayland/Hyprland
  ];
}
