_: {
  boot.supportedFilesystems = [
    "exfat"
    "xfs"
    "udf"
  ];

  fileSystems = {
    "/" = {
      device = "/dev/mapper/main2-sys";
      fsType = "xfs";
      options = [
        "rw"
        "relatime"
        "lazytime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/C6FE-B058";
      fsType = "vfat";
    };

    "/zero" = {
      device = "/dev/mapper/argon-zero";
      fsType = "xfs";
      options = [
        "x-systemd.automount"
        "relatime"
        "lazytime"
        "rw"
      ];
    };

    "/one" = {
      device = "/dev/mapper/xenon-one";
      fsType = "xfs";
      options = ["x-systemd.automount" "relatime" "lazytime" "rw"];
    };

    "/home/neg/music" = {
      device = "/one/music";
      options = ["bind" "nofail" "x-systemd.automount"];
    };
    "/home/neg/torrent" = {
      device = "/one/torrent";
      options = ["bind" "nofail" "x-systemd.automount"];
    };
    "/home/neg/vid" = {
      device = "/one/vid";
      options = ["bind" "nofail" "x-systemd.automount"];
    };
    "/home/neg/games" = {
      device = "/one/games";
      options = ["bind" "nofail" "x-systemd.automount"];
    };
    "/home/neg/doc" = {
      device = "/one/doc";
      options = ["bind" "nofail" "x-systemd.automount"];
    };
    "/var/lib/flatpak" = {
      device = "/one/flatpak";
      options = ["bind" "nofail" "x-systemd.automount"];
    };
    "/home/neg/.local/share/Steam/userdata" = {
      device = "/zero/userdata_steam";
      options = ["bind" "nofail" "x-systemd.automount"];
    };
    "/home/neg/.local/share/wineprefixes" = {
      device = "/zero/wineprefixes";
      options = ["bind" "nofail" "x-systemd.automount"];
    };
    "/home/neg/.cache/winetricks" = {
      device = "/zero/winetricks_cache";
      options = ["bind" "nofail" "x-systemd.automount"];
    };
  };

  swapDevices = [];
}
