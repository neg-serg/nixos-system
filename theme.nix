{ lib, config, pkgs, ... }:
with rec {
    alkano-aio = pkgs.callPackage ./theme/alkano-aio.nix {};
}; {
    stylix = {
        image = pkgs.fetchurl {
            url = "https://i.imgur.com/t3bTk2b.jpg";
            sha256 = "sha256-WVDIxyy9ww39JNFkMOJA2N6KxLMh9cKjmeQwLY7kCjk=";
        };
        base16Scheme = {
            base00 = "#020202"; # Background
            base01 = "#010912"; # Alternate background(for toolbars)
            base02 = "#8d9eb2"; # Scrollbar highlight ???
            base03 = "#15181f"; # Selection background
            base04 = "#6c7e96"; # Alternate(darker) text
            base05 = "#8d9eb2"; # Default text
            base06 = "#ff0000"; # Light foreground (not often used)
            base07 = "#00ff00"; # Light background (not often used)
            base08 = "#8a2f58"; # Error (I use red for it)
            base09 = "#914e89"; # Urgent (I use magenta or yellow for it)
            base0A = "#005faf"; # Warning, progress bar, text selection
            base0B = "#005200"; # Green
            base0C = "#005f87"; # Cyan
            base0D = "#0a3749"; # Alternative window border
            base0E = "#5B5BBB"; # Purple
            base0F = "#162b44"; # Brown
        };
        cursor.size = 35;
        cursor.name = "Alkano-aio";
        cursor.package = alkano-aio;
        polarity = "dark";
        fonts = {
            serif = { name = "Cantarell"; package = pkgs.cantarell-fonts; };
            sansSerif = { name = "Cantarell"; package = pkgs.cantarell-fonts; };
            # monospace = { name = "Iosevka"; package = pkgs.iosevka; };
            sizes = { applications = 10; desktop = 10; };
        };
    };
}
