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

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LANG = "en_US.UTF-8";
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Navigation
      ll = "eza -la --icons --git";
      ls = "eza --icons";
      la = "eza -la --icons";
      lt = "eza --tree --icons";
      cat = "bat";

      # Git
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";

      # Nix
      nrs = "sudo nixos-rebuild switch";
      nrb = "sudo nixos-rebuild boot";
      nrt = "sudo nixos-rebuild test";

      # Editors
      v = "nvim";
      vim = "nvim";

      # System
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
    };

    initExtra = ''
      # Better history search
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      # FZF integration
      if command -v fzf &> /dev/null; then
        eval "$(fzf --zsh)"
      fi
    '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "chalkan3";
    userEmail = "chalkan3@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[x](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = " ";
      };
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };

  # Neovim - managed manually via ~/.config/nvim
  programs.neovim.enable = false;
}
