{pkgs, ...}: {
  imports = [
    ./timesyncd
  ];

  # Journald: keep logs across reboots to inspect boot output
  services.journald.extraConfig = ''
    Storage=persistent
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
