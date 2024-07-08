{...}: {
  imports = [
    ./bash.nix
    ./dbus.nix
    ./fonts.nix
    ./games
    ./locale.nix
    ./locate.nix
    ./psd # profile sync daemon
    ./session
    ./xdg.nix
  ];
}
