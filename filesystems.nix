{ config, lib, pkgs, modulesPath, ... }:
{
  # UUID=C06B-349A /boot  vfat rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro 0  2
  # /dev/main/sys   /                         f2fs      rw,relatime,lazytime,background_gc=off,no_heap,inline_xattr,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,active_logs=6,alloc_mode=default,fsync_mode=posix                                                                                  0  1
  # /dev/main/home  /home                     f2fs      x-systemd.automount,rw,relatime,lazytime,background_gc=off,no_heap,inline_xattr,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,active_logs=6,alloc_mode=default,fsync_mode=posix                                                       0  1
  # /dev/argon/zero                           /zero                     f2fs      rw,defaults,x-systemd.automount,relatime,lazytime     0  0
  # /dev/xenon/one                            /one                      f2fs      rw,defaults,x-systemd.automount,relatime,lazytime     0  0
  # /one/music                                /home/neg/music           none      nofail,x-systemd.automount,bind                       0  0
  # /one/torrent                              /home/neg/torrent         none      nofail,x-systemd.automount,bind                       0  0
  # /one/vid                                  /home/neg/vid             none      nofail,x-systemd.automount,bind                       0  0
  # /one/games                                /home/neg/games           none      nofail,x-systemd.automount,bind                       0  0
  # /one/mail                                 /home/neg/.local/mail     none      nofail,x-systemd.automount,bind                       0  0
  # /zero/opt                                 /opt                      none      nofail,x-systemd.automount,bind                       0  0
  # /zero/flatpak                             /home/neg/.var            none      nofail,x-systemd.automount,bind                       0  0
  # tmpfs                                     /dev/shm                  tmpfs     defaults,rw,nosuid,noexec,nodev,size=32g              0  0

  fileSystems."/" = {
      device = "/dev/mapper/xenon-nix";
      fsType = "f2fs";
  };

  fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/C06B-349A";
      fsType = "vfat";
  };

  fileSystems."/home" = {
      device = "/dev/mapper/main-home";
      fsType = "f2fs";
  };

  fileSystems."/one" = {
      device = "/dev/mapper/xenon-one";
      fsType = "f2fs";
  };

  fileSystems."/zero" = {
      device = "/dev/mapper/argon-zero";
      fsType = "f2fs";
  };

  fileSystems."/home/neg/music"={device="/one/music"; options=["bind"];};
  fileSystems."/home/neg/torrent"={device="/one/torrent"; options=["bind"];};
  fileSystems."/home/neg/vid"={device="/one/vid"; options=["bind"];};
  fileSystems."/home/neg/games"={device="/one/games"; options=["bind"];};
  fileSystems."/home/neg/.var"={device="/zero/flatpak"; options=["bind"];};
  swapDevices = [];
}
