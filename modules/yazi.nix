{ config, lib, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      manager = {
        sort_dir_first = true;
        # show_hidden = true;
        # show_symlink = true;
      };
      preview = {
        max_width = 1500;
        max_height = 1500;
      };
    };
  };
}
