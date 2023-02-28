{                                                                            

  description = "boticelli's first flake";                                        
  # inputs are like channels for flake files
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # outputs is where we configure `inputs`
  # outputs = { self, nixpkgs, home-manager, ... }:
  outputs = inputs: {

    # define some variables for the ease of use
    let
      system = "x86_64-linux";
      user = "boticelli";

      pkgs = import nixpkgs {

        # takes nixpkgs path from the system
        inherit system;

        # use proprietory soft
        config.allowunfree = true;
      };

      lib = nixpkgs.lib;

    in {
      # this has to have "Configuration" in 
      # it's name to be usable by flake
      nixosConfigurations = {

        # user name is used when building a flake  
        ${user} = lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ./configuration.nix 

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };

        #<second user> = lib.nixosSystem {
        #inherit system;
        #modules = [ ./configuration.nix ];
        #};

        };
      };
  };
}   
