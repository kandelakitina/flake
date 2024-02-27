{ config, lib, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };
}
