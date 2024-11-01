{pkgs, lib, config, ...}: with {
  not_main = lib.mkIf (config.networking.hostName != "telfir");
}; {
  environment.systemPackages = with pkgs; not_main [
    keyd # systemwide key manager
  ];
  services.keyd.enable = not_main true;
  services.keyd.keyboards = not_main {
    default = {
      ids = ["*"];
      settings = {
        main = {
          capslock = "layer(capslock)";
        };
        "capslock:C" = {
          "0" = "M-0";
          "a" = "home";
          "e" = "end";
          "j" = "down";
          "k" = "up";
          "1" = "up";
          "2" = "down";
          "q" = "escape";
          "`" = "asciitilde";
          "-" = "backspace";
          "h" = "backspace";
        };
      };
    };
  };
}
