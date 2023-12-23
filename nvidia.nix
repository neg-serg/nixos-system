{ config, lib, pkgs, ... }:
{
    hardware.opengl={
        enable=true;
        driSupport=true;
        driSupport32Bit=true;
    };
    boot.blacklistedKernelModules=[ "nouveau" ];
    boot.extraModprobeConfig=''
        blacklist nouveau
        # blacklist nvidiafb
        blacklist snd_hda_intel
        blacklist snd_hda_codec_hdmi
        blacklist snd_hda_codec
        blacklist snd_hda_core
        # Obscure network protocols
        blacklist ax25
        blacklist netrom
        blacklist rose
        # Old or rare or insufficiently audited filesystems
        blacklist adfs
        blacklist affs
        blacklist bfs
        blacklist befs
        blacklist cramfs
        blacklist efs
        blacklist erofs
        blacklist exofs
        blacklist freevxfs
        blacklist vivid
        blacklist gfs2
        blacklist ksmbd
        blacklist cramfs
        blacklist freevxfs
        blacklist jffs2
        blacklist hfs
        blacklist hfsplus
        blacklist squashfs
        blacklist udf
        blacklist hpfs
        blacklist jfs
        blacklist minix
        blacklist nilfs2
        blacklist omfs
        blacklist qnx4
        blacklist qnx6
        blacklist sysv
        blacklist ufs
        
        options nouveau modeset=0
        '';

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
        package=config.boot.kernelPackages.nvidiaPackages.production;
    };
}
