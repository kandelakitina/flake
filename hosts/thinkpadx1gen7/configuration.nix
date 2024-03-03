{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [

    # this uses git:NixOS/nixos-hardware module to import settings
    # `inputs.hardware.nixosModules` refers to `inputs` (see above)
    # `inputs` are passed down here from flake.nix
    # inputs in flake.nix contains `hardware` modules and a url

    # models can be found here:
    # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    inputs.hardware.nixosModules.lenovo-thinkpad-x1-7th-gen

    ./hardware-configuration.nix

    # this is for disko partition manager
    # ./disks.nix

    # ../../nixos
    #../../nixos/optional/egpu.nix

    # TODO: importing user settings
    # ../../nixos/users/boticelli.nix
  ];

  networking = {
    hostName = "thinkpadx1gen7";
  };

  # # Modules come from nixos.pkgs
  # modules.nixos = {
  #   avahi.enable = true;
  #   auto-hibernate.enable = false;
  #   backup.enable = true;
  #   bluetooth.enable = true;
  #   docker.enable = true;
  #   fingerprint.enable = true;
  #   gaming.enable = true;
  #   login.enable = true;
  #   extraSecurity.enable = true;
  #   power.enable = true;
  #   virtualisation.enable = true;
  #   vpn.enable = true;
  # };

  # # some headset app
  # environment.systemPackages = with pkgs; [
  #   headsetcontrol2
  #   headset-charge-indicator
  # ];
  # services.udev.packages = [pkgs.headsetcontrol2];
 
  # nixpkgs.config.allowUnfree = true;

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
      helix
    ];
    variables.EDITOR = "hx"; # sets default editor
  };

  # Define a user account. 
  # Don't forget to set a password with ‘passwd’.
  users.users.boticelli = {
    isNormalUser = true;
    shell = pkgs.fish; # set default shell
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "password"; # change it with `pwd` upon restart
    packages = with pkgs; [
    # tmux
    # thunderbird
    ];
  };


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

  programs.fish.enable = true;

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
  system.stateVersion = "23.11"; # Did you read the comment?

  # FLAKES
  # ------
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

}
