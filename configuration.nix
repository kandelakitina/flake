# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  user = "boticelli";
  version = "23.11";
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # <home-manager/nixos>
    ];
 
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

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Russia/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # TODO: Add russian locale
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
      qutebrowser
      curl
      git
      htop
      micro
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
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "${version}"; # Did you read the comment?

  # FLAKES
  # ------
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

}
