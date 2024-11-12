{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (openvpn.override {
      pkcs11Support = true;
      pkcs11helper = pkgs.pkcs11helper;
    })
    openconnect # ciscoanyconnect open source
    update-resolv-conf # /etc/resolv.conf with DNS settings that come from the received push dhcp-options
  ];
}
