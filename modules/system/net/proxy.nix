{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    v2raya # web-based proxy manager
    v2ray # cli proxy manager
  ];
}
