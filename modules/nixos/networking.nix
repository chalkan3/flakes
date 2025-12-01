# Networking configuration module
{ config, lib, pkgs, ... }:

{
  networking = {
    # Disable legacy networking
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;

    # DNS servers
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  # Systemd-networkd for modern networking
  systemd.network = {
    enable = true;

    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      dhcpV4Config = {
        UseDNS = false;  # Use our own DNS
      };
    };
  };

  # Systemd-resolved for DNS
  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  };
}
