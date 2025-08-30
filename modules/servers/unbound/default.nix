{...}: {
  services.unbound = {
    enable = true;
    settings = {
      server.interface = ["127.0.0.1"];
      server.port = 5353;
      server.do-tcp = "yes";
      server.do-udp = "yes";
      server.verbosity = 1;
    };
  };
}
