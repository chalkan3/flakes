# Zellij configuration
{ config, lib, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      theme = "tokyo-night";
      default_shell = "zsh";
      pane_frames = true;
      auto_layout = true;
      default_layout = "compact";
      mouse_mode = true;
      scroll_buffer_size = 100000;
      copy_on_select = true;

      ui = {
        pane_frames = {
          rounded_corners = true;
        };
      };

      themes = {
        tokyo-night = {
          fg = "#a9b1d6";
          bg = "#1a1b26";
          black = "#414868";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#c0caf5";
          orange = "#ff9e64";
        };
      };

      keybinds = {
        normal = {
          "bind \"Alt h\"" = { MoveFocus = "Left"; };
          "bind \"Alt l\"" = { MoveFocus = "Right"; };
          "bind \"Alt j\"" = { MoveFocus = "Down"; };
          "bind \"Alt k\"" = { MoveFocus = "Up"; };
        };
      };
    };
  };

  # Add zellij to packages
  home.packages = with pkgs; [
    zellij
  ];
}
