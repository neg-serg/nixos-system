{inputs, ...}: {
  nix = {
    settings = {
      system-features = [
        "big-parallel"
        "gccarch-znver3"
        "gcctune-znver3"
      ];
      experimental-features = [
        "auto-allocate-uids"
        "ca-derivations"
        "flakes"
        "nix-command"
      ];
      trusted-users = [
        "root"
        "neg"
      ];
      substituters = [
        "https://ezkea.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      use-xdg-base-directories = false;
      max-jobs = 20;
      cores = 32;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 21d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.stable.flake = inputs.nixpkgs-stable;
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;
  };
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.hostPlatform = {
  #     gcc.arch = "znver3";
  #     gcc.tune = "znver3";
  #     system = "x86_64-linux";
  # };
}
