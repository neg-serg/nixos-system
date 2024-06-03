{...}: {
  boot.supportedFilesystems = [
    "bcachefs"
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

  fileSystems."/one" = {
    device = "/dev/mapper/xenon-one";
    fsType = "f2fs";
    options = ["x-systemd.automount" "relatime" "lazytime"];
  };

  # fileSystems."/zero" = {
  #   device = "/dev/mapper/argon-zero";
  #   fsType = "f2fs";
  #   options = [
  #       "x-systemd.automount"
  #       "relatime"
  #       "lazytime"
  #       "rw"
  #   ];
  # };

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
  swapDevices = [];
}
