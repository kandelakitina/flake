{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      f = ''
        fff $argv
        set -q XDG_CACHE_HOME; or set XDG_CACHE_HOME $HOME/.cache
        cd (cat $XDG_CACHE_HOME/fff/.fff_d)
      ''};
  };
}