# Users configuration module
{ config, lib, pkgs, ... }:

{
  # Root user configuration
  users.users.root = {
    shell = pkgs.zsh;
    hashedPassword = "";  # Empty password for container
  };

  # Allow passwordless sudo for wheel group
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Default shell for all users
  users.defaultUserShell = pkgs.zsh;
}
