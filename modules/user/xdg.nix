{
  inputs,
  pkgs,
  ...
}: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      inputs.xdg-desktop-portal-hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-termfilechooser
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = ["hyprland" "gtk"];
      common."org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      hyprland.default = ["hyprland" "gtk"];
      hyprland."org.freedesktop.impl.portal.FileChooser" = ["gtk"];
    };
  };
}
