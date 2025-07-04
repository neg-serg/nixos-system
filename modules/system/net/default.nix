{pkgs, ...}: {
  imports = [
    ./nscd.nix
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

  services.dnsmasq.enable = true;
  services.dnsmasq.settings = {
    interface = "br0";
    dhcp-range = "192.168.122.50,192.168.122.150,12h";
    dhcp-option = [
      "option:router,192.168.122.1"
      "option:dns-server,192.168.122.1"
    ];
    bind-interfaces = true;
  };

  environment.systemPackages = with pkgs; [
    impala # tui for wifi management
  ];

  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;
    netdevs."br0" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br0";
      };
    };
    networks."10-lan" = {
      matchConfig.Name = "net0";
      networkConfig.DHCP = "ipv4";
    };
    networks."11-lan" = {
      matchConfig.Name = "net1";
      networkConfig.DHCP = "ipv4";
    };
    networks."10-br0" = {
      matchConfig.Name = "br0";
      address = [ "192.168.122.1/24" ];
    };
  };
  services.udev.extraRules = ''
    KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0e", NAME="net0"
    KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0f", NAME="net1"
  '';
}
