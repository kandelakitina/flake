{
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # home-manager.users.boticelli = import ../../hosts/${config.networking.hostName}/home.nix;

  # sops.secrets.boticelli-password = {
  #   sopsFile = ./secrets.yaml;
  #   neededForUsers = true;
  # };

  #users.mutableUsers = false;
  users.users.boticelli = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups =
      [
        "wheel"
        "video"
        "audio"
      ]
      ++ ifTheyExist [
        "networkmanager"
        "libvirtd"
        "kvm"
        "docker"
        "podman"
        "git"
        "network"
        "wireshark"
        "i2c"
        "tss"
        "plugdev"
      ];

    #hashedPasswordFile = config.sops.secrets.boticelli-password.path;
    packages = [pkgs.home-manager];
  };

  programs.fish.enable = true;
}
