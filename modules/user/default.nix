{...}: {
  imports = [
    ./bash.nix
    ./dbus.nix
    ./games
    ./locale.nix
    ./locate.nix
    ./psd # profile sync daemon
    ./session
    ./xdg.nix
  ];
}
