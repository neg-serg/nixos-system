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
          "h" = "left";
          "j" = "down";
          "k" = "up";
          "l" = "right";
          "2" = "down";
          "3" = "up";
          "p" = "insert";
          "q" = "escape";
          "-" = "backspace";
        };
      };
    };
  };
}
