{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    oniux # isolate Applications over Tor using Linux Namespaces
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
