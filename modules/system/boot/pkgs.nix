{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    efibootmgr # rule EFI boot
    efivar     # manipulate EFI variables
    os-prober  # detect other OSes on drives
    sbctl      # debugging and troubleshooting Secure Boot
  ];
}
