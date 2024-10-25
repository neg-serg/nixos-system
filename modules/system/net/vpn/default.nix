{pkgs, ...}:
with {
  amnesiawg-module = pkgs.callPackage ../../linux/amnesiawg {
    kernel = pkgs.linuxPackages_6_11.kernel;
  };
  amnesiawg-tools = pkgs.callPackage ../vpn/packages/amnesiawg-tools {
    amneziawg-go = pkgs.callPackage ../vpn/packages/amnesiawg-go {};
  };
}; {
  environment.systemPackages = with pkgs; [
    (openvpn.override {
      pkcs11Support = true;
      pkcs11helper = pkgs.pkcs11helper;
    })
    amnesiawg-module # kernel module for amnesiawg
    amnesiawg-tools # tools for amnesiawg
    update-resolv-conf # /etc/resolv.conf with DNS settings that come from the received push dhcp-options
    wireguard-tools # wireguard interface
  ];
  services.openvpn.servers = {
    work = {
      config = ''config /home/neg/.dotfiles/nix/.config/home-manager/secrets/crypted/work.ovpn '';
      autoStart = false;
    };
    ipmi = {
      config = ''config /home/neg/.dotfiles/nix/.config/home-manager/secrets/crypted/ipmi.ovpn '';
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
  systemd.paths.openvpn-ipmi = {
    enable = true;
    description = "OpenVPN for ipmi activation path";
    pathConfig = {
      PathChanged = "/run/user/1000/secrets/ipmi.pass";
    };
    wantedBy = ["multi-user.target"];
  };
}
