{ pkgs, ... }: {
    imports = [
        ./pkgs/cli.nix
        ./pkgs/dev.nix
        ./pkgs/display.nix
        ./pkgs/editor.nix
        ./pkgs/elf.nix
        ./pkgs/games.nix
        ./pkgs/git.nix
        ./pkgs/io.nix
        ./pkgs/monitoring.nix
        ./pkgs/network.nix
        ./pkgs/nixos.nix
        ./pkgs/python-lto.nix
        ./pkgs/secrets.nix
    ];
    environment.systemPackages = with pkgs; [
        kexec-tools # tools related to the kexec Linux feature

        ddrescue # data recovery tool
        foremost # files extact from structure

        bash-completion # generic bash completions
        nix-bash-completions # nix-related bash-completions
        nix-zsh-completions # nix-related zsh-completion

        terminus-nerdfont # font for tty

        keyd # systemwide key manager

        dmidecode # extract system/memory/bios info
        lm_sensors # sensors
        pciutils # manipulate pci devices
        schedtool # CPU scheduling
        usbutils # lsusb

        xorg.xdpyinfo # display info
    ];
}
