# Custom library functions
{ lib }:

{
  # Helper to create a host configuration
  mkHost = { system, hostname, users ? [ "root" ] }: {
    inherit system;
    specialArgs = { inherit hostname; };
  };

  # Helper to import all nix files in a directory
  importDir = dir:
    let
      files = builtins.readDir dir;
      nixFiles = lib.filterAttrs (n: v: v == "regular" && lib.hasSuffix ".nix" n && n != "default.nix") files;
    in
    map (f: dir + "/${f}") (builtins.attrNames nixFiles);
}
