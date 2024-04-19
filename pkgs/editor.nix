{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        vis # minimal editor
        neovim # better vim
        emacs # very extensible text editor
    ];
}
