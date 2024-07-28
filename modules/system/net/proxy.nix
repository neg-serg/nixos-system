{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nekoray # proxy manager
    v2raya # web-based proxy manager
    v2ray # cli proxy manager
  ];
}
