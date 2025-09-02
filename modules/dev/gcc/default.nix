{...}: {
  imports = [./autofdo.nix];

  environment.sessionVariables = {
    MAKEFLAGS = "-j$(nproc)";
  };
}
