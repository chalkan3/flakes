# Home Manager configuration for zapper
{ config, lib, pkgs, ... }:

{
  # Home Manager version
  home.stateVersion = "25.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # User info
  home.username = "root";
  home.homeDirectory = "/root";

  # Additional packages specific to this host
  home.packages = with pkgs; [
    # Add host-specific packages here
  ];

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LANG = "en_US.UTF-8";
  };

  # Neovim - managed manually via ~/.config/nvim
  programs.neovim.enable = false;
}
