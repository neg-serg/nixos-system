{ pkgs, ... }: {
  # Small Wayland tools used with Hyprland (wallpaper, screenshots, clipboard)
  environment.systemPackages = with pkgs; [
    swaybg          # simple background setter
    grim            # screenshot utility (Wayland)
    slurp           # region selector for grim
    wl-clipboard    # wl-copy / wl-paste
    swappy          # screenshot editor (optional)
  ];
}

