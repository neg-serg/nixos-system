{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    amnezia-vpn # amnezia VPN Client
    amneziawg-go # userspace Go implementation of AmneziaWG
    amneziawg-tools # tools for configuring AmneziaWG
    (openvpn.override {
      pkcs11Support = true;
      pkcs11helper = pkgs.pkcs11helper;
    })
    openconnect # ciscoanyconnect open source
    update-resolv-conf # /etc/resolv.conf with DNS settings that come from the received push dhcp-options
  ];
}
