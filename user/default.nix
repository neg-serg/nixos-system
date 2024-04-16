{ ... }: {
    imports = [
        ./audio
        ./video

        ./bash.nix
        ./games.nix
        ./locale.nix
        ./session.nix
        ./syncthing.nix
        ./xdg.nix
    ];
}
