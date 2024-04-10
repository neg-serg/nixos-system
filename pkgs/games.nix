{ pkgs, inputs, ... }: {
    environment.systemPackages = with pkgs; [
        (inputs.nix-gaming.packages.${pkgs.hostPlatform.system}.star-citizen.override {
            location="$HOME/games/star-citizen";
        })
    ];
}
