{
  pkgs,
  config,
  ...
}: {
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope; # the default, here in case I want to override it
  };

  # workaround attempt for letting gamescope bypass YAMA LSM
  # doesn't work, but doesn't hurt to keep this here
  security.wrappers.gamescope = {
    owner = "root";
    group = "root";
    source = "${config.programs.gamescope.package}/bin/gamescope";
    capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
  };

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
