{
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
    DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0b10", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"'
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="35ef", ATTRS{idProduct}=="2201", GROUP="users", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="35ef", ATTRS{idProduct}=="2200", GROUP="users", MODE="0666"
  '';
}
