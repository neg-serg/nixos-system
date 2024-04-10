{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        vis # minimal editor
        neovim # better vim
    ];
}
