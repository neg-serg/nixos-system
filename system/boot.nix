{ pkgs, ... }: {
    imports = [
        ../pkgs/boot.nix
    ];
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
                darkmatter-theme = {
                    enable = true;
                    style = "nixos";
                    icon = "color";
                    resolution = "1440p";
                };
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
