##
# Module: system/net/proxy
# Purpose: V2Ray/V2RayA proxy utilities.
# Key options: none.
# Dependencies: pkgs.
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    v2raya # web-based proxy manager
    v2ray # cli proxy manager
  ];
}
