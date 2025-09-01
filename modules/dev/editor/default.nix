{ ... }: {
  programs.nano = { enable = false; };
  imports = [ ./pkgs.nix ];
}
