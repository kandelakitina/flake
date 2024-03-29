# TODO install https://github.com/joshmedeski/sesh

{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    functions = {
      # make fff file manager cd on quit
      # f = ''
      #   fff $argv
      #   set -q XDG_CACHE_HOME; or set XDG_CACHE_HOME $HOME/.cache
      #   cd (cat $XDG_CACHE_HOME/fff/.fff_d)
      # '';

      # make nnn file manager cd on quit
      f = ''
        if test -n "$NNNLVL" -a "$NNNLVL" -ge 1
            echo "nnn is already running"
            return
        end

        if test -n "$XDG_CONFIG_HOME"
            set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
        else
            set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
        end

        command nnn -e $argv

        if test -e $NNN_TMPFILE
            source $NNN_TMPFILE
            rm -- $NNN_TMPFILE
        end
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
      {
        name = "zoxide.fish";
        src = pkgs.fetchFromGitHub {
          owner = "kidonng";
          repo = "zoxide.fish";
          rev = "bfd5947bcc7cd01beb23c6a40ca9807c174bba0e";
          sha256 = "sha256-Hq9UXB99kmbWKUVFDeJL790P8ek+xZR5LDvS+Qih+N4=";
        };
      }
    ];
  };
}
