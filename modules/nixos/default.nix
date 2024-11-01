{
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep length;
  inherit (lib.lists) zipListsWith;
  inherit (lib.strings) escapeShellArg;
in {
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
    nurl # generate nix fetcher curl
    npins # pin different stuff ( inspired by niv )
    nurl # cli to generate Nix fetcher calls from repository URLs
    nvd # compare versions: nvd diff /run/current-system result
    statix # static analyzer for nix
  ];

  # create an overlay for nix-output-monitor to match the inconsistent
  # and frankly ugly icons with nerdfonts ones. they look a little larger
  # than before, but overall consistency is better in general.
  nixpkgs.overlays = [
    (_: prev: let
      oldIcons = [
        "↑"
        "↓"
        "⏱"
        "⏵"
        "✔"
        "⏸"
        "⚠"
        "∅"
        "∑"
      ];
      newIcons = [
        "f062" # 
        "f063" # 
        "f017" # 
        "f04b" # 
        "f00c" # 
        "f04c" # 
        "f071" # 
        "f1da" # 
        "f04a0" # 󰒠
      ];
    in {
      nix-output-monitor = assert length oldIcons == length newIcons;
        prev.nix-output-monitor.overrideAttrs (o: {
          postPatch =
            (o.postPatch or "")
            + ''
              sed -i ${escapeShellArg (
                concatStringsSep "\n" (zipListsWith (a: b: "s/${a}/\\\\x${b}/") oldIcons newIcons)
              )} lib/NOM/Print.hs

              sed -i 's/┌/╭/' lib/NOM/Print/Tree.hs
            '';
        });
    })
  ];
}
