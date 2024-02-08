{ config, lib, pkgs, nix-doom-emacs, stylix, username, email, theme, wm, browser, editor, spawnEditor, term, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/"+username;

  programs.home-manager.enable = true;

  imports = [ ../../user/app/games/games.nix # Various videogame apps
              ../../user/lang/godot/godot.nix # game development
              # ../../user/pkgs/blockbench.nix # blockbench
              ../../user/pkgs/flstudio.nix # flstudio (requires bottles)
            ];

  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core
    zsh
    alacritty
    dmenu
    rofi
    git
    syncthing

    spotify
    youtube-music
    discord
    tdesktop
    vscode

    # Media
    gimp-with-plugins
    pinta
    krita
    inkscape
    musikcube
    vlc

    yt-dlp
    #freetube

    blender
    cura
    obs-studio
    #install kdenlive via flatpak due to missing plugins
    #kdenlive
    (pkgs.writeScriptBin "kdenlive-accel" ''
      #!/bin/sh
      DRI_PRIME=0 flatpak run org.kde.kdenlive "$1"
    '')
    movit
    ffmpeg
    mediainfo
    libmediainfo
    mediainfo-gui
    audio-recorder

    # Office
    # libreoffice-fresh
    mate.atril
    xournalpp
    glib
    newsflash
    gnome.nautilus
    gnome.gnome-calendar
    gnome.seahorse
    gnome.gnome-maps
    openvpn
    protonmail-bridge
    texliveSmall

    wine
    bottles
    
  ];

  xdg.enable = true;
  xdg.userDirs = {
    extraConfig = {
      XDG_GAME_DIR = "${config.home.homeDirectory}/Media/Games";
      XDG_GAME_SAVE_DIR = "${config.home.homeDirectory}/Media/Game Saves";
    };
  };

}
