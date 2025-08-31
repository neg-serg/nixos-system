{pkgs, ...}: {
  imports = [
    ./nscd.nix
    ./pkgs.nix
    ./proxy.nix
    ./ssh.nix
    ./vpn
  ];
  services = {
    # systemd-resolved removed; AdGuardHome listens on :53 and forwards to Unbound on :5353
    udev.extraRules = ''
      KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0e", NAME="net0"
      KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0f", NAME="net1"
    '';
  };
  networking = {
    hostName = "telfir"; # Define your hostname.
    wireless.iwd.enable = true; # iwctl to manage wifi
    wireless.iwd.settings = {
      Settings = {AutoConnect = false;};
    };
    hosts = {
      "127.0.0.1" = ["localhost"];
      "::1" = ["localhost"];
    };
    useNetworkd = true;
    # Resolve via local AdGuardHome
    nameservers = ["127.0.0.1"];
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
    networks = {
      "10-lan" = {
        matchConfig.Name = "net0";
        networkConfig.DHCP = "ipv4";
        dhcpV4Config.UseDNS = true; # use DNS from MikroTik
        dhcpV4Config.UseRoutes = true; # apply default route from MikroTik
      };
      "11-lan" = {
        matchConfig.Name = "net1";
        networkConfig.DHCP = "ipv4";
        dhcpV4Config.UseDNS = true; # use DNS from MikroTik
        dhcpV4Config.UseRoutes = true; # apply default route from MikroTik
      };
      "10-br0" = {
        matchConfig.Name = "br0";
        address = ["192.168.122.1/24"];
        networkConfig.DHCPServer = "yes";
        dhcpServerConfig = {
          PoolOffset = 50; # start at .50
          PoolSize = 101; # up to .150 inclusive
          EmitDNS = true; # advertise DNS
          DNS = ["192.168.122.1"]; # host as DNS (AdGuardHome→Unbound)
          EmitRouter = true; # advertise default route
          Router = "192.168.122.1"; # host as router for guests
          DefaultLeaseTimeSec = 12 * 3600; # 12h (matches previous)
          MaxLeaseTimeSec = 24 * 3600; # 24h max
        };
      };
    };
  };
  # Allow DHCP server traffic on br0
  networking.firewall.interfaces.br0.allowedUDPPorts = [67 68];
}
