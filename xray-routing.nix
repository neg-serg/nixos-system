{ config, pkgs, ... }:
{
  services.xray.settings.routing.rules = [
    {
      inboundTag = [ "domestic-dns" ];
      outboundTag = "direct";
      type = "field";
    }
    {
      inboundTag = [ "dns-module" ];
      outboundTag = "proxy";
      type = "field";
    }
    {
      domain = [
        "domain:googleapis.cn"
        "domain:gstatic.com"
      ];
      outboundTag = "proxy";
      type = "field";
    }
    {
      network = "udp";
      outboundTag = "block";
      port = "443";
      type = "field";
    }
    {
      ip = [ "geoip:private" ];
      outboundTag = "direct";
      type = "field";
    }
    {
      domain = [ "geosite:private" ];
      outboundTag = "direct";
      type = "field";
    }
    {
      ip = [
        "223.5.5.5"
        "223.6.6.6"
        "2400:3200::1"
        "2400:3200:baba::1"
        "119.29.29.29"
        "1.12.12.12"
        "120.53.53.53"
        "2402:4e00::"
        "2402:4e00:1::"
        "180.76.76.76"
        "2400:da00::6666"
        "114.114.114.114"
        "114.114.115.115"
        "114.114.114.119"
        "114.114.115.119"
        "114.114.114.110"
        "114.114.115.110"
        "180.184.1.1"
        "180.184.2.2"
        "101.226.4.6"
        "218.30.118.6"
        "123.125.81.6"
        "140.207.198.6"
        "1.2.4.8"
        "210.2.4.8"
        "52.80.66.66"
        "117.50.22.22"
        "2400:7fc0:849e:200::4"
        "2404:c2c0:85d8:901::4"
        "117.50.10.10"
        "52.80.52.52"
        "2400:7fc0:849e:200::8"
        "2404:c2c0:85d8:901::8"
        "117.50.60.30"
        "52.80.60.30"
      ];
      outboundTag = "direct";
      type = "field";
    }
    {
      domain = [
        "domain:alidns.com"
        "domain:doh.pub"
        "domain:dot.pub"
        "domain:360.cn"
        "domain:onedns.net"
      ];
      outboundTag = "direct";
      type = "field";
    }
    {
      ip = [ "geoip:cn" ];
      outboundTag = "direct";
      type = "field";
    }
    {
      domain = [ "geosite:cn" ];
      outboundTag = "direct";
      type = "field";
    }
  ];
}
