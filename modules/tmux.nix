{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./configs/tmux.conf;
    plugins = with pkgs.tmuxPlugins; [
      # tpm
      yank
      urlview
      continuum
      resurrect
    ];
  };
}
