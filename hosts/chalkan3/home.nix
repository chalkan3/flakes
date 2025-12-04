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
    TERM = "xterm-256color";
  };

  # ─────────────────────────────────────────────────────────────────────
  # ZSH with Zinit + Powerlevel10k (copied from chalkan3's Mac config)
  # ─────────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Don't use home-manager's autosuggestions/syntax-highlighting
    # We use zinit for that with turbo mode for better performance
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;

    # Source the custom zshrc (NixOS 25.05+ uses initContent)
    initContent = ''
      # Source the full zshrc configuration
      [[ -f ~/.zshrc ]] && source ~/.zshrc
    '';
  };

  # ─────────────────────────────────────────────────────────────────────
  # Neovim - managed via dotfiles (Lazy.nvim)
  # ─────────────────────────────────────────────────────────────────────
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Let Lazy.nvim manage plugins via the dotfiles
    # We just install the base neovim and dependencies
  };

  # ─────────────────────────────────────────────────────────────────────
  # Git configuration
  # ─────────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    userName = "chalkan3";
    userEmail = "chalkan3@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
    # Use delta for better diffs
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
    };
  };

  # ─────────────────────────────────────────────────────────────────────
  # Dotfiles - copy zsh and nvim configs
  # ─────────────────────────────────────────────────────────────────────
  home.file = {
    # ZSH dotfiles
    ".zshrc".source = ./dotfiles/.zshrc;
    ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    ".zsh" = {
      source = ./dotfiles/zsh;
      recursive = true;
    };

    # Neovim dotfiles
    ".config/nvim" = {
      source = ./dotfiles/nvim;
      recursive = true;
    };
  };

  # ─────────────────────────────────────────────────────────────────────
  # Additional packages for the shell environment
  # ─────────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # Fonts (Nerd Fonts for p10k icons) - NixOS 25.05+ syntax
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack

    # Shell tools used by zsh config
    zoxide        # Smart cd
    eza           # Modern ls
    bat           # Modern cat
    fd            # Modern find
    ripgrep       # Modern grep
    fzf           # Fuzzy finder
    delta         # Git diff viewer
    direnv        # Environment switcher
    jq            # JSON processor
    yq            # YAML processor

    # Terminal multiplexer
    zellij
    tmux

    # System monitoring
    htop
    btop

    # Neovim dependencies
    tree-sitter   # For syntax highlighting
    nodejs_20     # For LSPs and plugins
    gcc           # For treesitter compilation
    gnumake

    # Utils
    curl
    wget
    unzip
    gzip
    gnutar
  ];
}
