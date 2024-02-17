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
    loginShellInitLast = ''
      echo -e "\e[38;5;196m┏(-_-)┛\e[38;5;27m┗(-_-)┓\e[38;5;226m┗(-_-)┛\e[38;5;118m┏(-_-)┓\e[0m"
    '';
    plugins = with pkgs.fishPlugins; [ 
      tide
      done
      fzf-fish
      forgit
      hydro
      grc
    ];
  };
}