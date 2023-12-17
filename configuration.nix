# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "telfir"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  systemd.packages = [ pkgs.packagekit ];
  services.xserver = {
    layout = "us,ru";
    xkbVariant = "";
    xkbOptions = "grp:alt_shift_toggle";
  };
  # Enable CUPS to print documents.
  services.printing.enable = false;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.xserver.libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.neg = {
    isNormalUser = true;
    description = "neg";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "systemd-journal" ];
    packages = with pkgs; [
      firefox
      i3
      mpd
      mpv
      ncmpcpp
      emacs
      telegram-desktop
    ];
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = { enable = true; };
  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "neg";
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    flatpak
    git
    neovim
    wget
    zsh
  ];
  environment.shells = with pkgs; [ zsh ];

  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.openssh.enable = true;
  # (man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
