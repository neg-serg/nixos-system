{inputs, pkgs, ...}: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-termfilechooser
    ];
    config = {
      common.default = [ "hyprland" ];
      common."org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      hyprland.default = [ "hyprland" ];
      hyprland."org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
    };
  };
}
