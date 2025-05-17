{inputs, ...}: {
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      show-trace = true;
      system-features = [
        "big-parallel"
      ];
      experimental-features = [
        "auto-allocate-uids" # allow nix to automatically pick UIDs, rather than creating nixbld* user accounts
        "ca-derivations" # content addressed nix
        "flakes" # flakes for reprodusability
        "nix-command" # new nix interface
        "recursive-nix" # let nix invoke itself
      ];
      trusted-users = [
        "root"
        "neg"
      ];
      substituters = [
        "https://0uptime.cachix.org"
        "https://cache.lix.systems"
        "https://ezkea.cachix.org"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
      ];
      trusted-public-keys = [
          "0uptime.cachix.org-1:ctw8yknBLg9cZBdqss+5krAem0sHYdISkw/IFdRbYdE="
          "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
          "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      ];
      connect-timeout = 5; # Bail early on missing cache hits (thx to nyx)
      cores = 24;
      max-jobs = 24;
      use-xdg-base-directories = true;
      warn-dirty = false; # Disable annoying dirty warn
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 21d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;
  };
  nixpkgs.config.allowUnfree = true;
}
