_: {
  networking = {
    hostName = "telfir";
    hosts."192.168.2.240" = ["telfir" "telfir.local"];
  };

  # Rename NICs to stable names specific to this host
  services.udev.extraRules = ''
    KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0e", NAME="net0"
    KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0f", NAME="net1"
  '';

  systemd.network = {
    # base enabling is in modules/system/net; define host-specific units here
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
        dhcpV4Config.UseDNS = true;
        dhcpV4Config.UseRoutes = true;
      };
      "11-lan" = {
        matchConfig.Name = "net1";
        networkConfig.DHCP = "ipv4";
        dhcpV4Config.UseDNS = true;
        dhcpV4Config.UseRoutes = true;
      };
      "10-br0" = {
        matchConfig.Name = "br0";
        address = ["192.168.122.1/24"];
        networkConfig.DHCPServer = "yes";
        dhcpServerConfig = {
          PoolOffset = 50;
          PoolSize = 101;
          EmitDNS = true;
          DNS = ["192.168.122.1"];
          EmitRouter = true;
          Router = "192.168.122.1";
          DefaultLeaseTimeSec = 12 * 3600;
          MaxLeaseTimeSec = 24 * 3600;
        };
      };
    };
  };

  # Allow DHCP server traffic on br0
  networking.firewall.interfaces.br0.allowedUDPPorts = [67 68];
}
