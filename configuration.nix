{
  hostname,
  config,
  pkgs1,
  pkgs2,
  wrapped,
  ...
}: let
  packages1 = with pkgs1; [
    emacs
    clementine
    obs-studio
    aseprite
    steam-run
    steam
    vlc
    krita
    blender
    audacity
    prismlauncher
    zoxide
    brightnessctl
    pavucontrol
    spotify
  ];
  packages2 = with pkgs2; [
    radicle-node
    firefox
    nvd
    hyfetch
    tokei
    git
    pinta
    python312
    python312Packages.deemix
    waybar
    dunst
    libnotify
    swww
    rofi-wayland
    dolphin
  ];
  allPackages = packages1 ++ packages2 ++ [wrapped.all];
in {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  # create swap memory
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 1 * 1024;
    }
  ];

  console.useXkbConfig = true;

  boot.supportedFilesystems = ["ntfs"];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  networking.hostName = hostname; # Define your hostname.
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

  environment.sessionVariables = {NIXOS_OZONE_WL = "1";};

  environment.systemPackages = allPackages;

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;

    xkb = {
      layout = "olivedv";
      extraLayouts.olivedv = {
        description = "Olive Dvorak";
        languages = ["us"];
        symbolsFile = ./olivedv_symbols.xkb;
      };
    };
  };

  # Skip entering password on boot
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "olive";
  };

  programs.hyprland = {
    enable = true;
    package = wrapped.hyprland // {override = _: wrapped.hyprland;}; # chat is she a true nixoser yet
    # we enable xwayland in the wrapper
    # xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs2.xdg-desktop-portal-gtk];
  };

  fonts.packages = [
    (pkgs1.nerdfonts.override {fonts = ["DroidSansMono"];})
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
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
    extraGroups = ["networkmanager" "wheel"];
    shell = wrapped.nushell;
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
