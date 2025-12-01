# NixOS modules index - imports all modules in this directory
{ ... }:

{
  imports = [
    ./nix.nix
    ./networking.nix
    ./packages.nix
    ./users.nix
  ];
}
