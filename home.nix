# TODO install fish, neovim, tmux, starship
# urlview for tmux
# TODO setup fzf
# TODO setup starship
# TODO setup fish
# TODO setup all .config

{ inputs, config, pkgs, ... }:

{
  imports = [
    ./modules/alacritty.nix
    ./modules/fish.nix
    # ./modules/tmux.nix
    # ./modules/zellij.nix
  ];

  # Starship
  programs = {
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

    # # Git
    git = {
      enable = true;
      delta.enable = true;
      userName = "boticelli";
      userEmail = "kandelakitina@gmail.com";
    };
  };

  # Shell aliases
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
    f = "fff";
    l = "eza -F -s type";
    la = "eza -F -a";
    ll = "eza -F -l --no-user -s type";
    lt = "eza --tree";
  };
  

  # Fonts
  fonts.fontconfig.enable = true;

  # GTK theme
  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
    cursorTheme.name = "Bibata-Modern";
    iconTheme.name = "GruvboxPlus";
  };

  xdg.mimeApps.defaultApplications = {
    "text/plain" = "nvim.desktop";
    "applications/pdf" = "zathura.desktop";
    "image/*" = "feh.desktop";
    "video/png" = "mpv.desktop";
    "video/jpg" = "mpv.desktop";
    "video/*" = "mpv.desktop";
  };

  # Packages
  home.packages = with pkgs; [
    
    # GUI
    # alacritty # terminal 
    firefox
    obsidian  # note taking app

    (nerdfonts.override { fonts = [ "Ubuntu" "UbuntuMono" ]; })

    # # Utils
    # home-manager    # nix home manager
    # gcc_multi       # make utils
    # direnv          # set env variables for folders
    # entr            # Run arbitrary commands when files change
    
    # cli apps
    bat       # better cat
    btop      # resourese manager
    delta     # better diff
    eza       # better ls
    lazygit   # git client
    helix     # editor
    gh        # github authentificator
    fd        # alternative to find
    fff       # simple file manager
    fzf       # fuzzy finder
    jq        # JSON formatter
    ripgrep   # better grep
    tree      # show file tree
    zoxide    # easy cli files navigator with z
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
  ];

  # TODO: add stuff from https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
  
  # basic configuration of git, please change to your own
  # programs = {

  #   # Better `cd`
  #   bat.enable = true;
  #   # Type `z <pat>` to cd to some directory
  #   zoxide.enable = true;
  #   # Type `<ctrl> + r` to fuzzy search your shell history
  #   fzf.enable = true;
  #   jq.enable = true;
  #   btop.enable = true;

  # };
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

  # Name
  home.username = "boticelli";
  home.homeDirectory = "/home/boticelli";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Turn off versions mismatch errors
  home.enableNixpkgsReleaseCheck = false;
  
  # Version of Home Manager with which this config works
  home.stateVersion = "23.11";
}
