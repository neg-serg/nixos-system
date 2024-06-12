{pkgs, ...}: {
  virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
  };
  environment.systemPackages = with pkgs; [
      dxvk # for plugins compatibility
      wine-staging # tool to run windows packages
      winetricks # stuff to install dxvk
  ];
  nix.settings.extra-sandbox-paths = ["/run/binfmt" "${pkgs.qemu}"];
  boot.binfmt = {
    registrations = {
      aarch64-linux.interpreter = "${pkgs.qemu}/bin/qemu-aarch64"; # aarch64 interpreter
      i686-linux.interpreter = "${pkgs.qemu}/bin/qemu-i686"; # i686 interpreter
    };
  };
}
