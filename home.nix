{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "boticelli";
  home.homeDirectory = "/home/boticelli";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    home-manager
    btop
    lazygit
    helix
    firefox
    gh
  ];

  # TODO: add stuff from https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
  
  # Version of Home Manager with which this config works
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.emacs = {
  #   enable = true;
  #   extraPackages = epkgs: [
  #     epkgs.nix-mode
  #     epkgs.magit
  #   ];
  # };
  #
  # services.gpg-agent = {
  #   enable = true;
  #   defaultCacheTtl = 1800;
  #   enableSshSupport = true;
  # };

}
