{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    obfs4 # circumvents censorship by transforming Tor traffic between clients and bridges
    oniux # isolate Applications over Tor using Linux Namespaces
    tor-browser # browse web via tor
    tractor # setup a proxy with Onion Routing via TOR and optionally obfs4proxy
  ];

  services = {
    tor = {
      enable = true;
      client.enable = true;
      client.dns.enable = true;
      settings = {
        ExitNodes = "{ua}, {nl}, {gb}";
        ExcludeNodes = "{ru},{by},{kz}";
      };
    };
    privoxy.enable = true;
    privoxy.enableTor = true;
  };
}
