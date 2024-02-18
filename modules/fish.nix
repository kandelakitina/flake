# TODO install https://github.com/joshmedeski/sesh

{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      f = ''
        fff $argv
        set -q XDG_CACHE_HOME; or set XDG_CACHE_HOME $HOME/.cache
        cd (cat $XDG_CACHE_HOME/fff/.fff_d)
      '';
    };
    interactiveShellInit = ''
      set fish_greeting (echo -e "\e[38;5;196m┏(-_-)┛\e[38;5;27m┗(-_-)┓\e[38;5;226m┗(-_-)┛\e[38;5;118m┏(-_-)┓\e[0m")
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      # Learn bindings on https://github.com/wfxr/forgit
      { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
    ];
  };
}
