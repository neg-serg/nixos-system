{ config, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  systemd = {
    network.wait-online.ignoredInterfaces = [ "tailscale0" ];
    services.tailscaled.environment.TS_DEBUG_FIREWALL_MODE = "nftables";
  };

  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
}
