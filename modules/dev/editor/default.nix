{pkgs, ...}: {
  programs.nano = {enable = false;}; # I hate nano to be honest
  environment.systemPackages = with pkgs; [
    neovim # better vim
    emacs # install emacs systemwide
  ];
}
