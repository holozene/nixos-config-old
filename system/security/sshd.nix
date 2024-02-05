{ config, pkgs, username, ... }:

{
  # Enable incoming ssh
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  # todo: add a way to define ssh keys in flake.nix
  users.users.${username}.openssh.authorizedKeys.keys = [
    ""
  ];
}
