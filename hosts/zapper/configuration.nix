# Zapper NixOS configuration
# Supports both LXC containers and VMs (auto-detected)
{ config, lib, pkgs, modulesPath, ... }:

let
  # Detect if running in a container by checking systemd container marker
  # This works at evaluation time by checking if we're building for a VM
  isContainer = config.boot.isContainer;
in
{
  imports = [
    # LXC container support (safe to include even for VMs)
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  # Hostname
  networking.hostName = "zapper";

  # System state version
  system.stateVersion = "25.05";

  # Boot configuration - set to false for VMs (can be overridden)
  boot.isContainer = lib.mkDefault false;

  # Bootloader for VMs - GRUB with nodev for Incus VMs
  boot.loader.grub = lib.mkIf (!config.boot.isContainer) {
    enable = true;
    device = "nodev";
    efiSupport = false;
    extraConfig = ''
      serial --unit=0 --speed=115200
      terminal_output serial console
      terminal_input serial console
    '';
  };

  # Filesystem for VMs (Incus uses virtio disks)
  fileSystems = lib.mkIf (!config.boot.isContainer) {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };

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
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pt_BR.UTF-8/UTF-8" ];

  # Console settings
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable zsh system-wide (default shell is set in modules/nixos/users.nix)
  programs.zsh.enable = true;

  # Root user configuration
  users.users.root = {
    # shell is defined in modules/nixos/users.nix
    # Set initial password for SSH access (change after first login)
    initialPassword = "nixos";
  };

  # Fonts - system-wide for console and GUI apps
  fonts = {
    packages = with pkgs; [
      # Nerd Fonts - NixOS 25.05+ syntax
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      liberation_ttf
      dejavu_fonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
      };
    };
  };

  # System packages (minimal - most are in home-manager)
  environment.systemPackages = with pkgs; [
    # Essential
    git
    vim
    curl
    wget

    # Shell
    zsh
  ];

  # Nix settings - gc is configured in modules/nixos/nix.nix
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    trusted-users = [ "root" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Networking
  networking = {
    # Use DHCP by default
    useDHCP = lib.mkDefault true;
    # Enable firewall but allow SSH
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  # Security
  security.sudo.wheelNeedsPassword = false;
}
