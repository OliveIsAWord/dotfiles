{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # create swap memory
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 1 * 1024;
  } ];

  console.useXkbConfig = true;

  boot.supportedFilesystems = [ "ntfs" ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  networking.hostName = "vespera"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Boise";
  # Sync hardware clock with local time rather than UTC.
  # In particular, this keeps the Windows system clock correct.
  time.hardwareClockInLocalTime = true;  

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  environment.variables = {
      EDITOR = "emacs";
      BROWSER = "firefox";
      TERM = "alacritty";
      SHELL = "nu"; # let's see if this works; it conflicts with users.users.olive.shell
      NIXPKGS_ALLOW_UNFREE = "1"; # hopefully this works too?
  };
  
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Skip entering password on boot
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "olive";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "Noto" ]; })
  ];

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "dvp";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.olive = {
    isNormalUser = true;
    description = "olive";
    extraGroups = [ "networkmanager" "wheel" ];
    #shell = packages.nushell;
    packages = with pkgs; [
      firefox
      emacs
      xorg.xmodmap
      clementine
      python312
      git
      pinta
      obs-studio
      python311Packages.deemix
      aseprite
      steam-run
      steam
      vlc
      krita
      blender
      audacity
      prismlauncher
      zoxide
      hyfetch
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
