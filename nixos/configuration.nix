{ config, lib, pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ ];

  networking.hostName = "nix";
  networking.networkmanager.enable = true;

  time.timeZone = "Pacific/Auckland";

  hardware.graphics.enable = true;
  hardware.i2c.enable = true;
  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.displayManager.ly.enable = true;
  programs.niri.enable = true;
  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = {};
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  hardware.bluetooth.enable = true;
  services.flatpak.enable = true;
  services.resolved.enable = true;
  #services.thermald.enable = true;
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	pulse.enable = true;
  };
  services.mullvad-vpn = {
	enable = true;
	package = pkgs.mullvad-vpn;
  };
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  users.users.floofy = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      wireplumber = inputs.stablepkgs.legacyPackages.${prev.system}.wireplumber;
    })
  ];

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    fastfetch
    yazi
    wl-clipboard
    btop
    ffmpeg
    inxi
    ddcutil
    gcc
    gnumake
    go
    mpv
    atuin
    bibata-cursors
    quickshell
    noctalia-shell
    kdePackages.qt5compat
    playerctl
    brightnessctl
    libsForQt5.qt5ct
    libsForQt5.qt5.qtbase
    pwvucontrol
    nvtopPackages.nvidia
    winetricks
    zenity
    wineWow64Packages.stable
    signal-desktop
    ripgrep
    xwayland-satellite
  ];

  services.openssh.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}

