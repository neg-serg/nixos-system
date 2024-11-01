{pkgs, ...}:
with {
  amneziawg-module = pkgs.callPackage ../../linux/amneziawg {
    kernel = pkgs.linuxPackages_6_11.kernel;
  };
  amneziawg-tools = pkgs.callPackage ../vpn/packages/amneziawg-tools {
    amneziawg-go = pkgs.callPackage ../vpn/packages/amneziawg-go {};
  };
}; {
  environment.systemPackages = with pkgs; [
    (openvpn.override {
      pkcs11Support = true;
      pkcs11helper = pkgs.pkcs11helper;
    })
    amneziawg-module # kernel module for amneziawg
    amneziawg-tools # tools for amneziawg
    openconnect # ciscoanyconnect open source
    update-resolv-conf # /etc/resolv.conf with DNS settings that come from the received push dhcp-options
    wireguard-tools # wireguard interface
  ];
  services.openvpn.servers = {
    work = {
      config = ''config /home/neg/.dotfiles/nix/.config/home-manager/secrets/crypted/work.ovpn '';
      autoStart = false;
    };
  };
  systemd.paths.openvpn-work = {
    enable = true;
    description = "OpenVPN for work activation path";
    pathConfig = {
      PathChanged = "/run/user/1000/secrets/work.pass";
    };
    wantedBy = ["multi-user.target"];
  };
}
