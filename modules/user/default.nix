{...}: {
  imports = [
    ./bash.nix
    ./dbus.nix
    ./games.nix
    ./locale.nix
    ./locate.nix
    ./psd # profile sync daemon
    ./session.nix
    ./syncthing.nix
    ./xdg.nix
  ];
}
