{ config, lib, pkgs, ... }:

{
  programs.nnn= {
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });
    # extraConfig = builtins.readFile ./configs/tmux.conf;
    # plugins = with pkgs.tmuxPlugins; [
    #   # tpm
    #   yank
    #   urlview
    #   continuum
    #   resurrect
    # ];
  };
}
