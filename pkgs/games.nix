{ pkgs, inputs, ... }: {
    boot.kernel.sysctl = {
        # NixOS configuration for Star Citizen requirements
        "vm.max_map_count" = 16777216;
        "fs.file-max" = 524288;
    };
    environment.systemPackages = with pkgs; [
        (inputs.nix-gaming.packages.${hostPlatform.system}.star-citizen.override {
            location="$HOME/games/star-citizen";
        })
    ];
}
