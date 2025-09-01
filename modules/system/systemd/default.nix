{pkgs, ...}: {
  imports = [
    ./timesyncd
  ];

  # Boot optimizations regarding filesystem:
  # Journald was taking too long to copy from runtime memory to disk at boot
  # set storage to "auto" if you're trying to troubleshoot a boot issue
  services.journald.extraConfig = ''
    Storage=auto
    SystemMaxFileSize=300M
    SystemMaxFiles=50
  '';

  services.logind.settings.Login = {
    IdleAction = "ignore";
  };

  systemd = {
    coredump.enable = true;
    settings = {
      Manager = {
        RebootWatchdogSec = "10s";
      };
    };
    # Favor user responsiveness; de-prioritize nix-daemon slightly
    slices."user.slice".sliceConfig = {
      CPUWeight = 10000;
      IOWeight = 10000;
    };
    services.nix-daemon.serviceConfig = {
      CPUWeight = 200;
      IOWeight = 200;
    };
    packages = [pkgs.packagekit];
  };
}
