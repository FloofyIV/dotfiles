{ config, lib, pkgs, inputs, unstable, ... }:

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
  boot.kernelModules = [ "thinkpad_acpi" "coretemp" ];

  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
  '';

  networking.hostName = "nix";
  networking.networkmanager.enable = true;

  time.timeZone = "Pacific/Auckland";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
  services.displayManager.ly.enable = true;
  programs.hyprland.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
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
	package = unstable.mullvad-vpn;
  };
  services.power-profiles-daemon.enable = true;
  services.undervolt = {
      enable = true;
      coreOffset = -100;
  };
  services.upower.enable = true;
  services.thinkfan = {
    enable = true;

  # typical ThinkPad fan interface
    fans = [
      { type = "tpacpi"; query = "/proc/acpi/ibm/fan"; }
    ];

    sensors = [
      { type = "hwmon"; query = "/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input"; }
    ];   
 

    levels = [
      [0 0 45]
      [1 45 52]
      [2 50 58]
      [3 55 63]
      [4 60 68]
      [5 65 72]
      [6 68 73]
      [7 72 75]
      ["level full-speed" 75 32767]
    ];
  };
  users.users.floofy = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    fastfetch
    kdePackages.dolphin
    yazi
    wl-clipboard
    unstable.btop
    ffmpeg
    inxi
    ddcutil
    gcc
    gnumake
    go
    mpv
    atuin
    hyprcursor
    bibata-cursors
    quickshell
    unstable.noctalia-shell
    kdePackages.qt5compat
    playerctl
    brightnessctl
    libsForQt5.qt5ct
    libsForQt5.qt5.qtbase
    pwvucontrol
    nvtopPackages.nvidia
    hyprshot
    winetricks
    zenity
    wineWow64Packages.stable
    signal-desktop
    ripgrep
    powertop
  ];

  services.openssh.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}

