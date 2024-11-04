{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1 This will make xdg-open use the portal to open programs, which resolves bugs
    # involving programs opening inside FHS envs or with unexpected env vars set from wrappers. See #160923 for more info.
    xdgOpenUsePortal = true;
    wlr = {enable = false;};
    config.common.default = "gtk";
  };
}
