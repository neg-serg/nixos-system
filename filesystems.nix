{ config, lib, pkgs, modulesPath, ... }: {
  boot.supportedFilesystems = [ "bcachefs" ];
  fileSystems."/" = {
      device = "/dev/mapper/main-sys";
      fsType = "f2fs";
      options = [
          "rw"
          "relatime"
          "lazytime"

          "active_logs=6"
          "alloc_mode=default"
          "background_gc=off"
          "extent_cache"
          "flush_merge"
          "fsync_mode=posix"
          "inline_data"
          "inline_dentry"
          "inline_xattr"
          "mode=adaptive"
          "no_heap"
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

  fileSystems."/zero" = {
      device = "/dev/mapper/argon-zero";
      fsType = "f2fs";
      options = ["x-systemd.automount" "relatime" "lazytime"];
  };

  fileSystems."/home/neg/music"={device="/one/music"; options=["bind" "nofail" "x-systemd.automount"];};
  fileSystems."/home/neg/torrent"={device="/one/torrent"; options=["bind" "nofail" "x-systemd.automount"];};
  fileSystems."/home/neg/vid"={device="/one/vid"; options=["bind" "nofail" "x-systemd.automount"];};
  fileSystems."/home/neg/games"={device="/one/games"; options=["bind" "nofail" "x-systemd.automount"];};
  fileSystems."/home/neg/doc"={device="/one/doc"; options=["bind" "nofail" "x-systemd.automount"];};
  swapDevices = [];
}
