{...}: {
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      dns = {
        upstream_dns = ["127.0.0.1:5353"];
        bootstrap_dns = ["1.1.1.1" "8.8.8.8"];
      };
    };
  };
}
