{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    amnezia-vpn # amnezia VPN Client
    amneziawg-go # userspace Go implementation of AmneziaWG
    amneziawg-tools # tools for configuring AmneziaWG
    netbird # connect your devices into a single secure private WireGuard®-based mesh network with SSO/MFA and simple access controls
    openconnect # ciscoanyconnect open source
    (openvpn.override {
      pkcs11Support = true;
      inherit (pkgs) pkcs11helper;
    })
    update-resolv-conf # /etc/resolv.conf with DNS settings that come from the received push dhcp-options
  ];
}
