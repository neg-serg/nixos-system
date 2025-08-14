{pkgs, ...}: {
  programs.ccache.enable = true; # enable systemwide ccache
  environment.sessionVariables = {
    USE_CCACHE = "1";
    MAKEFLAGS = "-j$(nproc)";
  };
}
