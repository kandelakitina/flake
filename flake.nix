{
  description = "My Nix Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # disko.url = "github:nix-community/disko";
    hardware.url = "github:nixos/nixos-hardware";
    # sops-nix.url = "github:mic92/sops-nix";
    # impermanence.url = "github:nix-community/impermanence";
    # lanzaboote.url = "github:nix-community/lanzaboote";

    # nixgl.url = "github:nix-community/nixGL";
    # nix-colors.url = "github:misterio77/nix-colors";

    # hypr-contrib.url = "github:hyprwm/contrib";
    # hyprland-nix.url = "github:spikespaz/hyprland-nix";
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # nixvim.url = "github:pta2002/nixvim";
    # nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
    # zjstatus.url = "github:dj95/zjstatus";

    # nwg-displays.url = "github:nwg-piotr/nwg-displays";
    # comma.url = "github:nix-community/comma";
    # nix-gaming.url = "github:fufexan/nix-gaming";

    # firefox-gnome-theme = {
    #   url = "github:rafaelmardojai/firefox-gnome-theme";
    #   flake = false;
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux"];
    forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
    pkgsFor = nixpkgs.legacyPackages;
  in {
    inherit lib;
    # nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    # overlays = import ./overlays {inherit inputs outputs;};
    # packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    # devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs inputs;});

    nixosConfigurations = {
      # iso = lib.nixosSystem {
      #   modules = [
      #     "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
      #     "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      #     ./hosts/iso/configuration.nix
      #   ];
      #   specialArgs = {inherit inputs outputs;};
      # };

      thinkpadx1gen7 = lib.nixosSystem {
        modules = [./hosts/thinkpadx1gen7/configuration.nix];
        specialArgs = {inherit inputs outputs;};
      };
    };

    homeConfigurations = {
      thinkpadx1gen7 = lib.homeManagerConfiguration {
        modules = [./hosts/thinkpadx1gen7/home.nix];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };

    };
  };
}
