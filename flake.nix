{                                                                            

  description = "boticelli's first flake";                                        
                                                                             
  # inputs are like channels for flake files
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
      systems = ["x86_64-linux" ];
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

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # this has to have "Configuration" in 
      # it's name to be usable by flake
      nixosConfigurations = {

        # user name is used when building a flake  
        ${user} = lib.nixosSystem {
          inherit systems pkgs;
          modules = [
            ./configuration.nix 

            # Adding home-manager as a NixOS system config module
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = {
                imports = [ ./home.nix ];
                # TODO fix
                # specialArgs = { inherit system user; };
              };
            }
        
          ];
        };


        #<second user> = lib.nixosSystem {
        #inherit system;
        #modules = [ ./configuration.nix ];
        #};

      };

      # # This configues home-manager config
      # # Should allow to run 'home-manager switch`
      # # TODO: try uncommenting it with nixos-unstable in input
      # homeConfigurations = {
      #   ${user} = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [ ./home.nix ];
      #   };
      # };

    };
}   
