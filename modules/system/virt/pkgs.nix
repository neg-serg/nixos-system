{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ctop                    # container metrics TUI
    dive                    # inspect Docker image layers
    dxvk                    # setup script for DXVK
    guestfs-tools           # virt-sysprep et al.
    lima                    # run Linux VMs
    nerdctl                 # Docker-compatible CLI for containerd
    podman-compose          # compose for Podman
    podman-tui              # Podman status TUI
    quickemu                # fast/simple VM builder
    vkd3d                   # DX12 for Wine
    wineWowPackages.staging # Wine (staging) for Windows apps
    winetricks              # helpers for Wine (e.g., DXVK)
  ];
}
