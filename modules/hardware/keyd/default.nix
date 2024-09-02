{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    keyd # systemwide key manager
  ];
  services.keyd.enable = true;
  services.keyd.keyboards = {
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
          "1" = "down";
          "2" = "up";
          "q" = "escape";
          "-" = "backspace";
          "h" = "backspace";
        };
      };
    };
  };
}
