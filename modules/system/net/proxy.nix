{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    hiddify-app # multi-platform proxy client
    nekoray # proxy manager
    v2raya # web-based proxy manager
    v2ray # cli proxy manager
  ];
}
