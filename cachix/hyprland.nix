{
  nix = {
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
      ];
      # Lix-specific trust knob retained from previous config
      trusted-substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
