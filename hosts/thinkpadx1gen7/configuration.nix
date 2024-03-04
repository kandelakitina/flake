{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # inputs.hardware.nixosModules.framework-13-7040-amd
    ./hardware-configuration.nix
    # ./disks.nix

    ../../nixos
    #../../nixos/optional/egpu.nix
    ../../nixos/users/boticelli.nix
  ];

  networking = {
    hostName = "thinkpadx1gen7";
  };

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

  # environment.systemPackages = with pkgs; [
  #   headsetcontrol2
  #   headset-charge-indicator
  # ];
  # services.udev.packages = [pkgs.headsetcontrol2];

  # swapDevices = [{device = "/swap/swapfile";}];
  # boot = {
  #   kernelParams = [
  #     "amdgpu.sg_display=0"
  #     "resume_offset=533760"
  #   ];
  #   blacklistedKernelModules = ["hid-sensor-hub"];
  #   supportedFilesystems = lib.mkForce ["btrfs"];
  #   kernelPackages = pkgs.linuxPackages_latest;
  #   loader = {
  #     systemd-boot.enable = true;
  #     efi.canTouchEfiVariables = true;
  #   };
  #   resumeDevice = "/dev/disk/by-label/nixos";
  #   # lanzaboote = {
  #   #   enable = true;
  #   #   pkiBundle = "/etc/secureboot";
  #   # };
  # };

  # boot.plymouth = {
  #   enable = true;
  #   themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
  #   theme = "catppuccin-mocha";
  # };
  # boot.initrd.systemd.enable = true;

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

  system.stateVersion = "23.11";
}
