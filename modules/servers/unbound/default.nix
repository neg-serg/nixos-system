{...}: {
  services.unbound = {
    enable = true;
    settings = {
      server.interface = [ "127.0.0.1" ];
      server.port = 53;
      server.do-tcp = "yes";
      server.do-udp = "yes";
      server.verbosity = 1;
    };
  };
}
