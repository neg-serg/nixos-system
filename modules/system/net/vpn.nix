{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (openvpn.override {
      pkcs11Support = true;
      pkcs11helper = pkgs.pkcs11helper;
    })
    protonvpn-gui # protonvpn
    update-resolv-conf # /etc/resolv.conf with DNS settings that come from the received push dhcp-options
    wireguard-tools # stuff to rule wireguard
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
