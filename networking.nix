{ config, lib, pkgs, modulesPath, ... }:
{
    networking.hostName = "telfir"; # Define your hostname.
    networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;
    networking.useDHCP = lib.mkDefault true;
    systemd.services = {
        NetworkManager-wait-online.enable = false; # Unconditionally disable this Removes the time in the startup where the system waits for a connection
    };
    # networking.networkmanager.dns = "systemd-resolved";
    # services.resolved.enable = true;
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
