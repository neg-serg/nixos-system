{ pkgs, ... }:
with {
  fallout = pkgs.fetchFromGitHub {
    owner = "shvchk";
    repo = "fallout-grub-theme";
    rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
    sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
  };
}; {
    boot = {
        loader = {
            efi.canTouchEfiVariables = true;
            grub = {
                enable = true;
                efiSupport = true;
                useOSProber = true;
                device = "nodev";
                backgroundColor = "#000000";
                font = "${pkgs.terminus_font_ttf}/share/fonts/truetype/TerminusTTF-Bold.ttf";
                fontSize = 32;
                gfxmodeEfi = "2560x1440";
                gfxpayloadEfi = "keep";
                theme = fallout;
                # theme = "${
                #     (pkgs.fetchFromGitHub {
                #      owner = "13atm01";
                #      repo = "GRUB-Theme";
                #      rev = "95bcc240162bce388ac2c0bec628b2aaa56e6cb8";
                #      sha256 = "0xnx82fdyjqw89qmacwmlva9lis3zs8b0l1xi67njpypjy29sdnc";
                #      })
                # }/Touhou\ Project/Touhou-project/";
            };
            timeout = 1;
        };
        initrd = {
            availableKernelModules = [
                "nvme"
                "sd_mod"
                "usb_storage"
                "usbhid"
                "xhci_hcd"
                "xhci_pci"
            ];
            kernelModules = [];
        };
    };
}
