{pkgs, ...}: {
  environment.etc."ppp/options".text = "ipcp-accept-remote";

  environment.systemPackages = with pkgs; [
    (openvpn.override {
      pkcs11Support = true;
      pkcs11helper = pkgs.pkcs11helper;
    })
    openconnect # ciscoanyconnect open source
    openfortivpn # yet another vpn service
    update-resolv-conf # /etc/resolv.conf with DNS settings that come from the received push dhcp-options
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
