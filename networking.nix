{ config, lib, pkgs, modulesPath, ... }:
{
    networking.hostName = "telfir"; # Define your hostname.
    networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
    systemd.network.enable = true;
    systemd.network.networks."10-lan" = {
        matchConfig.Name = "net0";
        networkConfig.DHCP = "ipv4";
    };
    systemd.network.networks."11-lan" = {
        matchConfig.Name = "net1";
        networkConfig.DHCP = "ipv4";
    };

    services.udev.extraRules = ''
        KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0e", NAME="net0"
        KERNEL=="eth*", ATTR{address}=="fc:34:97:b7:16:0f", NAME="net1"
    '';
    environment.etc = {
        "resolv.conf".text = ''
            nameserver 1.1.1.1
            nameserver 192.168.88.1
            nameserver 172.20.64.1 # OpenVPN defined name servers
            nameserver 127.0.0.53 # System defined name servers
            options edns0
        '';
    };
}
