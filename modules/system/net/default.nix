{
  imports = [
    ./pkgs.nix
    ./proxy.nix
    ./ssh.nix
    ./tor.nix
    ./vpn
  ];
  networking = {
    hostName = "telfir"; # Define your hostname.
    wireless.iwd.enable = true; # iwctl to manage wifi
    wireless.iwd.settings = {
      Settings = { AutoConnect = false; };
    };
    useNetworkd = true;
    nameservers = [
      "8.8.8.8"
      "192.168.0.1"
      "172.20.64.1" # OpenVPN defined name servers
      "127.0.0.53" # System defined name servers
    ];
  };

  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;
    networks."10-lan" = {
      matchConfig.Name = "net0";
      networkConfig.DHCP = "ipv4";
    };
    networks."11-lan" = {
      matchConfig.Name = "net1";
      networkConfig.DHCP = "ipv4";
    };
  };
  services.udev.extraRules = ''
    KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0e", NAME="net0"
    KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0f", NAME="net1"
  '';
}
