{...}: {
  imports = [
    ./bash.nix
    ./dbus.nix
    ./fonts.nix
    ./games
    ./locale.nix
    ./locale-pkgs.nix
    ./locate.nix
    ./psd # profile sync daemon
    ./session
    ./session/pkgs.nix
    ./xdg.nix
  ];
}
