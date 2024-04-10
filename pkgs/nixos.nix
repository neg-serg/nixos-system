{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        alejandra # the uncompromising nix code formatter
        cached-nix-shell # nix-shell with instant startup
        cachix # for downloading pre-built binaries
        dconf2nix # convert dconf to nix config
        deadnix # scan for dead nix code
        manix # nixos documentation
        nh # some nice nix commands
        niv # pin different stuff
        nix-diff # show what causes derivation to be different
        nix-index # index for nix-locate
        nix-init # provides more easy way to create nix packages
        nix-output-monitor # fancy nix output (nom)
        nix-tree # Interactive scan current system / derivations for what-why-how depends
        nixos-shell # tool to create vm for current config
        npins # pin different stuff ( inspired by niv )
        nurl # cli to generate Nix fetcher calls from repository URLs
        nvd # compare versions: nvd diff /run/current-system result
        statix # static analyzer for nix
    ];
}
