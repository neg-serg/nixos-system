{pkgs, ...}: {
  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  environment.systemPackages = with pkgs; [
    bandwhich # display network utilization per process
    cacert # for curl certificate verification
    curlie # feature-rich httpie
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
    magic-wormhole # secure transfer between computers
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
    trippy # net analysis tool like ping + traceroute
    w3m # cli browser

    axel # console downloading program
    curl # transfer curl
    wget2 # non-interactive downloader

    aircrack-ng # stuff for wifi security
    hcxdumptool # wpa scanner
    netsniff-ng # sniffer
    tshark # sniffer tui
    wireshark # sniffer gui
  ];
}
