_: {
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      dns = {
        upstream_dns = ["127.0.0.1:5353"];
        bootstrap_dns = ["1.1.1.1" "8.8.8.8"];
        # Local rewrites so LAN clients can resolve Nextcloud host
        rewrites = [
          { domain = "telfir"; answer = "192.168.2.240"; }
          { domain = "telfir.local"; answer = "192.168.2.240"; }
        ];
      };
    };
  };
}
