{pkgs, stable, ...}: {
  environment.systemPackages = with pkgs; [
    openvpn # gnu/gpl vpn

    bandwhich # display network utilization per process
    cacert # for curl certificate verification
    dnsutils # dns command-line tools (dig, nslookup)
    ethtool # control eth hardware and drivers
    fping # like ping -c1
    geoip # geoip lookup
    httpie # fancy curl
    httpstat # fancy curl -v
    iftop # display bandwidth
    inetutils # common network programs
    ipcalc # calculate ip addr stuff
    iputils # set of small useful utilities for Linux networking
    stable.magic-wormhole # secure transfer between computers
    netcat-openbsd # openbsd netcat variant
    netdiscover # another network scan
    nettools # controlling the network subsystem in Linux
    nmap # port scanner
    rclone # rsync for cloud storage
    socat # multipurpose relay
    sshfs # ssh mount
    tcpdump # best friend to show network stuff
    tcptraceroute # traceroute without icmp
    traceroute # basic traceroute
    w3m # cli browser

    curl # transfer curl
    wget2 # non-interactive downloader

    aircrack-ng # stuff for wifi security
    hcxdumptool # wpa scanner
    netsniff-ng # sniffer
    tshark # sniffer tui
    wireshark # sniffer gui
  ];
}
