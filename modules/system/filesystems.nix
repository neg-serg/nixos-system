{...}: {
  boot.supportedFilesystems = [
    "exfat"
    "xfs"
  ];

  fileSystems."/" = {
    device = "/dev/mapper/main-sys";
    fsType = "xfs";
    options = [
      "rw"
      "relatime"
      "lazytime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C06B-349A";
    fsType = "vfat";
  };

fileSystems."/zero" = {
  device = "/dev/mapper/argon-zero";
  fsType = "xfs";
  options = [
    "x-systemd.automount"
    "relatime"
    "lazytime"
    "rw"
  ];
};

fileSystems."/one" = {
  device = "/dev/mapper/xenon-one";
  fsType = "xfs";
  options = ["x-systemd.automount" "relatime" "lazytime" "rw"];
};

fileSystems."/home/neg/music" = {
  device = "/one/music";
  options = ["bind" "nofail" "x-systemd.automount"];
};
fileSystems."/home/neg/torrent" = {
  device = "/one/torrent";
  options = ["bind" "nofail" "x-systemd.automount"];
};
fileSystems."/home/neg/vid" = {
  device = "/one/vid";
  options = ["bind" "nofail" "x-systemd.automount"];
};
fileSystems."/home/neg/games" = {
  device = "/one/games";
  options = ["bind" "nofail" "x-systemd.automount"];
};
fileSystems."/home/neg/doc" = {
  device = "/one/doc";
  options = ["bind" "nofail" "x-systemd.automount"];
};
fileSystems."/var/lib/flatpak" = {
  device = "/one/flatpak";
  options = ["bind" "nofail" "x-systemd.automount"];
};
  swapDevices = [];
}
