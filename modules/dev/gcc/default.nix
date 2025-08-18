{pkgs, ...}: {
  environment.sessionVariables = {
    MAKEFLAGS = "-j$(nproc)";
  };
}
