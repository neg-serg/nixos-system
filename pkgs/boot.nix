{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        efibootmgr # rule efi boot
        efivar # manipulate efi vars
        os-prober # utility to detect other OSs on a set of drives
    ];
}
