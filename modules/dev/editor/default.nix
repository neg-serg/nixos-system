{pkgs, ...}: {
  programs.nano = {enable = false;}; # I hate nano to be honest
  environment.systemPackages = with pkgs; [
    vis # minimal editor
    neovim # better vim
    emacs # very extensible text editor
  ];
}
