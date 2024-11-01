{
  pkgs,
  ...
}: {
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = false;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };

  programs.gamescope = {
    enable = false;
    package = pkgs.gamescope; # the default, here in case I want to override it
  };

  environment.systemPackages = with pkgs; [ protontricks ];

  security.wrappers.gamemode = {
    owner = "root";
    group = "root";
    source = "${pkgs.gamemode}/bin/gamemoderun";
    capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
    };
  };

}
