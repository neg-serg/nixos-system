{
    networking = {
        hostName = "telfir"; # Define your hostname.
        wireless.iwd.enable = true; # iwctl to manage wifi
        useNetworkd = true;
        nameservers = [
            "1.1.1.1"
            "192.168.88.1"
            "172.20.64.1" # OpenVPN defined name servers
            "127.0.0.53" # System defined name servers
            # options edns0
        ];
    };
    systemd.network = {
        enable = true;
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
