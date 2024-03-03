## File structure and explanation

├── flake.lock
│      # locks versions of user packages
│      # update with `nix flake update`
│
├── flake.nix
│      # entry point, when evaluated produces outputs:
│      # nixOS config, home-manager, overlays, custom packages, custom devShells
│      # imports lots of files
│      # to install use `sudo nixos-rebuild switch --flake .#systemName`
│
├── home-manager
│   │  # folder for home-manager configs for different categories of apps
│   │
│   ├── default.nix
│   │      # entry point for folder. imports other files in the folder
│   │
│   └── shells
│       └── fish.nix
│ 
├── hosts
│   │  # contains configs for each PC
│   │   
│   └── thinkpadx1gen7
│       ├── configuration.nix
│       │      # Main system config. Imports:
│       │      #  - hardware configs, including hardware-configuration.nix
│       │      #  - user config from `nixos/users/...` (see below)
│       │
│       ├── hardware-configuration.nix
│       │      # Hardware configs
│       │
│       └── home.nix
│              # Main home-manager config. Enables main apps 
│              # and imports `home-manager/default.nix`
│              
├── modules
│   │  # Folder collects universal modules for NixOS and Home-manager
│   │
│   ├── home-manager
│   │   └── default.nix
│   └── nixos
│       └── default.nix
│
├── nixos
│   └── users
│       │  # Contains user configs (user-name, group etc)
│       │
│       └── boticelli.nix
