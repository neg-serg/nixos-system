{ config, lib, pkgs, ... }:
{
    hardware.opengl={
        enable=true;
        driSupport=true;
        driSupport32Bit=true;
    };
    boot.blacklistedKernelModules=[
        "nouveau"
        # blacklist nvidiafb
        "snd_hda_intel"
        "snd_hda_codec_hdmi"
        "snd_hda_codec"
        "snd_hda_core"
        # Obscure network protocols
        "ax25"
        "netrom"
        "rose"
        # Old or rare or insufficiently audited filesystems
        "adfs"
        "affs"
        "bfs"
        "befs"
        "cramfs"
        "efs"
        "erofs"
        "exofs"
        "freevxfs"
        "vivid"
        "gfs2"
        "ksmbd"
        "cramfs"
        "freevxfs"
        "jffs2"
        "hfs"
        "hfsplus"
        "squashfs"
        "udf"
        "hpfs"
        "jfs"
        "minix"
        "nilfs2"
        "omfs"
        "qnx4"
        "qnx6"
        "sysv"
        "ufs"
        # Disable watchdog for better performance
        # wiki.archlinux.org/title/improving_performance#Watchdogs
        "sp5100_tco"
    ];
    boot.extraModprobeConfig='' options nouveau modeset=0 '';

    environment={
        systemPackages=with pkgs; [glxinfo];
        variables={ 
            __GL_GSYNC_ALLOWED="0"; 
        };
    };

    services.xserver={screenSection=''Option         "metamodes" "3440x1440_175 +0+0 {AllowGSYNCCompatible=Off}"'';};
    services.xserver.videoDrivers=["nvidia"];
    hardware.nvidia={
        open=false; # Currently alpha-quality/buggy, so false is currently the recommended setting.
        nvidiaSettings=true;
    };
}
