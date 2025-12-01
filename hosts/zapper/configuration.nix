# Zapper container configuration
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # LXC container support
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  # Hostname
  networking.hostName = "zapper";

  # System state version
  system.stateVersion = "25.05";

  # Boot configuration for containers
  boot.isContainer = true;

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  # Timezone
  time.timeZone = "America/Sao_Paulo";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Console settings
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Shells
    zsh
    bash

    # Editors
    neovim
    vim

    # Version control
    git

    # Terminal tools
    tmux
    zellij
    htop
    btop

    # File management
    tree
    eza
    bat
    fd
    ripgrep
    fzf

    # Network tools
    curl
    wget
    jq

    # Development
    gnumake
    gcc

    # Utilities
    unzip
    zip
    gzip
    gnutar
  ];

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
}
