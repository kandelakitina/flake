# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  user = "boticelli";
  version = "22.11";
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # <home-manager/nixos>
    ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  
  # Dual boot
  boot = { 
    kernelPackages = pkgs.linuxPackages_latest;
    # initrd.kernelModules = ["nvidia_x11"];
    loader = {
      timeout = 5;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
        # /boot will probably work too
      };
      grub  = {
        enable = true;
        configurationLimit = 5;
        #device = ["nodev"];
        # Generate boot menu but not actually installed
        devices = ["nodev"];
        # Install grub
        efiSupport = true;
        useOSProber = true;
        # OSProber looks for installed systems
        # Or use extraEntries like seen with Legacy
        # OSProber will probably not find windows partition on first install. 
        # Just do a rebuild than.
      };
    };
  };


  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Russia/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # TO-DO: Add russian locale
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # i18n.extraLocaleSettings = {
  #   LC_TIME = "ru_RU.UTF-8";
  #   LC_MONETARY = "ru_RU.UTF-8";
  # };
  console = {
    font = "Ubuntu-Mono";
    keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Custom
  services = {
    spice-vdagentd.enable = true; # Clipboard share in VM
    xserver = {
      enable = true;
      layout = "us,ru";
      xkbOptions = "caps:escape";
      displayManager = {
        gdm.enable = true;
        # lightdm.enable = true;
        defaultSession = "gnome";
      };
      desktopManager = {
        # xfce.enable = true;
        gnome.enable = true;
      };
      windowManager.bspwm.enable = true;
    };
    # enable software that you want to run as a service, e.g.:
    # plex.enable = true;
  };
  

  # HARDWARE
  # --------
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # SOFTWARE
  # -----
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      firefox
      git
      htop
      micro
      neovim
      wget
    ];
    variables.EDITOR = "micro"; # sets default editor
  };

  # Define a user account. 
  # Don't forget to set a password with ‘passwd’.
  users.users.${user}= {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "password"; # change it with `pwd` upon restart
    packages = with pkgs; [
    # tmux
    # thunderbird
    ];
  };

  # Home Manager
  # home-manager.users.${user} = { pkgs, ... }: {
    # home.stateVersion = "${version}";
    # home.packages = with pkgs; [
      # bat
      # ranger
    # ];

    # services = {
    #   dunst.enable = true;
    # };
    
    # # import dotfiles
    # home.file.".doom.d" = {
    #   source ./doom.d;
    #   recursive = true;
    #   onChange = builtins.readFile ./doom.sh;
    # };
    # home.file.".config/polybar/script/mic.sh" = {
    #   source = ./mic.sh;
    #   executable = true;
    # };

    # see https://github.com/MatthiasBenaets/nixos-config/blob/master/nixos.org#declared 
    # for how to generate dotfiles from configuration.nix
  # };


  nixpkgs.config.allowUnfree = true;

  # Auto update the system
  # system.autoUpgrade = {
  #   enable = true;
  #   channel = "https://channels.nixos.org/nixos-${version}";
  # };

  # Auto collect garbage
  # nix = {
  #   settings.auto-optimise-store = true;
  #   gc = {
  #     automatic = true;
  #     dates = "weekly";
  #     options = "--delete-older-than 7d";
  #   };
  # };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "${version}"; # Did you read the comment?

  # FLAKES
  # ------
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

}
