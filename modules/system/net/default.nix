{pkgs, lib, ...}: {
  imports = [
    ./nscd.nix
    ./pkgs.nix
    ./proxy.nix
    ./ssh.nix
    ./tor.nix
    ./vpn
  ];
  services = {
    resolved = {
      enable = true;
      # Forward all DNS queries to local unbound on 127.0.0.1:5353
      extraConfig = ''
        DNS=127.0.0.1:5353
        Domains=~.
      '';
    };
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
    # Rely on systemd-resolved to forward to unbound; no direct nameserver needed here.
    nameservers = [];
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
      };
    };
  };
}
