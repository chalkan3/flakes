# Zsh configuration with Zinit and Powerlevel10k
{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    # History settings
    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    # Zinit plugin manager (NixOS 25.05+ uses initContent)
    initContent = ''
      # ═══════════════════════════════════════════════════════════════════════
      # Zinit Setup
      # ═══════════════════════════════════════════════════════════════════════
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"

      if [[ ! -d "$ZINIT_HOME" ]]; then
        mkdir -p "$(dirname $ZINIT_HOME)"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      fi

      source "''${ZINIT_HOME}/zinit.zsh"

      # ═══════════════════════════════════════════════════════════════════════
      # Powerlevel10k Theme
      # ═══════════════════════════════════════════════════════════════════════
      zinit ice depth=1
      zinit light romkatv/powerlevel10k

      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # ═══════════════════════════════════════════════════════════════════════
      # Essential Plugins
      # ═══════════════════════════════════════════════════════════════════════
      zinit light zsh-users/zsh-autosuggestions
      zinit light zsh-users/zsh-completions
      zinit light zsh-users/zsh-syntax-highlighting
      zinit light Aloxaf/fzf-tab

      # ═══════════════════════════════════════════════════════════════════════
      # Completion Settings
      # ═══════════════════════════════════════════════════════════════════════
      autoload -Uz compinit && compinit
      zinit cdreplay -q

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

      # ═══════════════════════════════════════════════════════════════════════
      # Key Bindings
      # ═══════════════════════════════════════════════════════════════════════
      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      bindkey '^[[3~' delete-char
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      # ═══════════════════════════════════════════════════════════════════════
      # FZF Integration
      # ═══════════════════════════════════════════════════════════════════════
      eval "$(fzf --zsh)"

      # ═══════════════════════════════════════════════════════════════════════
      # Powerlevel10k Config
      # ═══════════════════════════════════════════════════════════════════════
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';

    # Shell aliases
    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Listings
      ls = "ls --color=auto";
      ll = "ls -lah";
      la = "ls -A";
      l = "ls -CF";

      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      glog = "git log --oneline --graph --decorate";

      # Editor
      v = "nvim";
      vim = "nvim";

      # Safety nets
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      # System
      reload = "source ~/.zshrc";

      # NixOS
      nrs = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
      nfu = "nix flake update";
    };
  };
}
