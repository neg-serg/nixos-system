nix-ld = {
            enable = true;
            libraries = with pkgs; [
                stdenv.cc.cc # commonly needed
                zlib # commonly needed
                openssl # commonly needed
                mesa
                glib
                fontconfig
                libgpg-error
                freetype
                alsa-lib
                dbus
                expat
                libz
                nss
                pciutils
                util-linux
            ];
        };
