{ config, pkgs, ... }:

{
  imports = [
    ./modules/alacritty.nix
  ];

  home.shellAliases = {
    g = "git";
    lg = "lazygit";
    f = "fff";
  };
  
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "boticelli";
  home.homeDirectory = "/home/boticelli";

  # Turn off versions mismatch errors
  home.enableNixpkgsReleaseCheck = false;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # TODO install fish, neovim, tmux, starship
    # urlview for tmux
    # taskwarrior
    # TODO setup fzf
    # TODO setup starship
    # TODO setup fish
    # TODO setup all .config
    
    # GUI
    alacritty # terminal 
    firefox
    obsidian  # note taking app

    # # Utils
    # home-manager    # nix home manager
    # gcc_multi       # make utils
    # direnv          # set env variables for folders
    # entr            # Run arbitrary commands when files change
    
    # cli apps
    # bat       # better cat
    # btop      # resourese manager
    eza       # better ls
    lazygit   # git client
    helix     # editor
    gh        # github authentificator
    fd        # alternative to find
    fff       # simple file manager
    # fzf       # fuzzy finder
    # jq        # JSON formatter
    ripgrep   # better grep
    tree      # show file tree
    # zoxide    # easy cli files navigator with z
    zk        # note taking
    xclip     # system buffer manager

    # Development and LSPs
    nodejs
    deno
    nodePackages.bash-language-server
    marksman
    nodePackages.yaml-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages_latest.typescript-language-server
    # [python3]=python311
    # [python3.11-pip]=python311Packages.pip
    # [python3.11-python-lsp-server]=python311Packages.python-lsp-server
    (nerdfonts.override { fonts = [ "Ubuntu" "UbuntuMono" ]; })
  ];

  # TODO: add stuff from https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
  
  # Version of Home Manager with which this config works
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  # basic configuration of git, please change to your own
  programs = {
    git = {
      enable = true;
      userName = "boticelli";
      userEmail = "kandelakitina@gmail.com";
    };

    # Better `cd`
    bat.enable = true;
    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    btop.enable = true;

    fish = {
      enable = true;
    };
  
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    }; 
  };
  # # alacritty - a cross-platform, GPU-accelerated terminal emulator
  #   alacritty = {
  #     enable = true;
  #     # custom settings
  #     settings = {
  #       env.TERM = "xterm-256color";
  #       font = {
  #         size = 16;
  #         draw_bold_text_with_bright_colors = true;
  #       };
  #       scrolling.multiplier = 5;
  #       selection.save_to_clipboard = true;
  #     };
  #   };
  # };

  # Fonts
  fonts.fontconfig.enable = true;

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
