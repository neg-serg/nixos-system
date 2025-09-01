{ ... }: {
  programs.zsh = { enable = true; };
  imports = [ ./pkgs.nix ];
}
