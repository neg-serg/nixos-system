{pkgs, ...}: {
  # Small Wayland tools used with Hyprland (wallpaper, screenshots, clipboard)
  environment.systemPackages = with pkgs; [
    swaybg # simple wallpaper setter
    grimblast # Hyprland-friendly screenshots (wraps grim+slurp+wl-copy)
    wl-clipboard # wl-copy / wl-paste
    swappy # screenshot editor (optional)
    hyprpicker # color picker for Wayland/Hyprland
  ];
}
