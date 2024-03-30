{ ... }: {
   services.syncthing = {
       enable = true;
       user = "neg";
       dataDir = "/zero/data";
       configDir = "/zero/syncthing-config";
       overrideDevices = true;     # overrides any devices added or deleted through the WebUI
       overrideFolders = true;     # overrides any folders added or deleted through the WebUI
       settings = {
         devices = {
           "telfir" = { id = "GNB553I-2IUWVBA-OCGXUVZ-BP322Q2-S5EGA5O-HNI5IWM-TJ4CEI6-547A5QI"; };
           "Pixel 7 Pro" = { id = "OWGOTRT-Q4LV2MR-QLVIFZH-LPWZ4DP-TANYCAM-SXC2W2A-BL4VSHS-KWXLVAB"; };
         };
         folders = {
           "music-upload" = { # Name of folder in Syncthing, also the folder ID
               path = "/zero/music-upload"; # Which folder to add to Syncthing
               devices = [ "Pixel 7 Pro" "telfir" ]; # Which devices to share the folder with
           };
           "picture-upload" = { # Name of folder in Syncthing, also the folder ID
               path = "/zero/picture-upload"; # Which folder to add to Syncthing
               devices = [ "Pixel 7 Pro" "telfir" ]; # Which devices to share the folder with
           };
        };
      };
   };
   # Syncthing ports: 8384 for remote access to GUI
   # 22000 TCP and/or UDP for sync traffic
   # 21027/UDP for discovery
   # source: https://docs.syncthing.net/users/firewall.html
   networking.firewall.allowedTCPPorts = [ 8384 22000 ];
   networking.firewall.allowedUDPPorts = [ 22000 21027 ];

   services.syncthing.settings.gui = {
       user = "neg";
       password = "ithee3Ye";
   };
}
