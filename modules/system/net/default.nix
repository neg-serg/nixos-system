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
    useNetworkd = true;
    nameservers = ["127.0.0.1" "::1"];
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      server_names = [
        # "8.8.8.8"
        # "192.168.0.1"
        # "172.20.64.1" # OpenVPN defined name servers
        # "127.0.0.53" # System defined name servers
      ];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  services.resolved = {
    enable = true;  
    dnssec = "true";
    dnsovertls = "opportunistic";
  };

  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;
    networks."10-lan" = {
      matchConfig.Name = "net0";
      networkConfig.DHCP = "ipv4";
      dns = ["127.0.0.1" "::1"];
    };
    networks."11-lan" = {
      matchConfig.Name = "net1";
      networkConfig.DHCP = "ipv4";
      dns = ["127.0.0.1" "::1"];
    };
  };

  services.udev.extraRules = ''
    KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0e", NAME="net0"
    KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0f", NAME="net1"
  '';
}
