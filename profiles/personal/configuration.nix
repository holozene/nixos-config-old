{ config, lib, pkgs, blocklist-hosts, username, name, hostname, timezone, locale, wm, theme, ... }:

{
  imports =
    [ ( import ../../system/app/docker.nix {storageDriver = "btrfs"; inherit username pkgs config lib;} )
      ../../system/hardware/openrgb.nix
      ../../system/app/gamemode.nix
      ../../system/app/steam.nix
      ../../system/app/prismlauncher.nix
    ];
}
