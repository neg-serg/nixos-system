_: {
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = ["127.0.0.1"];
        port = 5353;
        "do-tcp" = "yes";
        "do-udp" = "yes";
        verbosity = 1;
      };
    };
  };
}
