{                                                                            

  description = "boticelli's second flake";                                        
                                                                             
  # inputs are like channels for flake files
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # provides handy helpers for configuration.nix
    hardware.url = "github:nixos/nixos-hardware";
  };

  # Outputs is what is produced from inputs
  # `self` is this document.
  # We bind variables to `@inputs` so that they will be available like `inputs.self.lib`.
  outputs = { self, nixpkgs, home-manager, ... }@inputs:

    # with `let .. in` we define variables
    let

      # `self` is this document. It has `outputs`
      # Line below allows referring it outputs without `self`
      # the same like `outputs = self.outputs`
      inherit (self) outputs;

      # binds 'lib' to two sources
      lib = nixpkgs.lib // home-manager.lib;
      
      # This bit is instead of writing out for each system:
      # pkgs = nixpkgs.legacyPackages.x86_64_linux;
      systems = ["x86_64-linux"];

      # This is a definitions of a  helper function, 
      # which applies arguments to lists of systems (above)
      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
      pkgsFor = nixpkgs.legacyPackages;

      user = "boticelli";

      # pkgs = import nixpkgs {

      #   # takes nixpkgs path from the system
      #   inherit systems;

      #   # # use proprietory soft
      #   config = {
      #     allowUnfree = true;
      #     permittedInsecurePackages = [
      #       "electron-25.9.0"
      #     ];
      #   };
      # };

    in {

      # add `lib` into outputs scope
      inherit lib;

      # linking additional config files for system and user

      # nixosModules = import ./modules/nixos;
      # homeManagerModules = import ./modules/home-manager;

      # An overlay in Nix is a way to add, modify, or remove
      # packages from the Nix package set. Overlays are functions
      # that take two arguments: the original package set
      # and a set of functions from the Nix library. 
      # The `inherit` bit passes down inputs and outputs from this
      # file to files in ./overlays 
      # - `inputs` comes from `@inputs` above
      # - `outputs` comes from `inherit (self) outputs`

      # overlays = import ./overlays {inherit inputs outputs;};
     

      # this imports packages and devShells for every system

      # packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
      # devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs inputs;});

      # this has to have "Configuration" in 
      # it's name to be usable by flake
      nixosConfigurations = {

        # name of system config
        thinkpadx1gen7 = lib.nixosSystem {

          # refers to a difference file for actual config
          modules = [./hosts/thinkpadx1gen7/configuration.nix];

          # passed does `inputs` and `outputs` variables
          specialArgs = {inherit inputs outputs;};
        };
      };

      # home manager (user-wide) congifs
      homeConfigurations = {
        thinkpadx1gen7 = lib.homeManagerConfiguration {
          modules = [./hosts/thinkpadx1gen7/home.nix];

          # bind `pkgs` variable
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          # passes down variables
          extraSpecialArgs = {inherit inputs outputs;};
        };
    };
  };
}
