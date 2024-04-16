{ inputs, ... }: {
    nix = {
        settings = {
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
        daemonIOSchedPriority = 4;
    };
    nixpkgs.config.allowUnfree = true;
}
