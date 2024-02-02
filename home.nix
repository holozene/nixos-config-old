{ config, lib, pkgs, stdenv, fetchurl, nix-doom-emacs, stylix, username, email, dotfilesDir, theme, wm, browser, editor, spawnEditor, term, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/"+username;

  programs.home-manager.enable = true;
  home-manager.useUserPackages = true;

  imports = [
              nix-doom-emacs.hmModule
              stylix.homeManagerModules.stylix
              (./. + "../../../user/wm"+("/"+wm+"/"+wm)+".nix") # My window manager selected from flake
              ../../user/shell/sh.nix # zsh
              ../../user/shell/cli-collection.nix # useful CLI apps
              ../../user/bin/phoenix.nix # nix command wrapper
              ../../user/app/ranger/ranger.nix # ranger file manager config
              ../../user/app/git/git.nix # git config
              # ../../user/app/keepass.nix # password manager
              (./. + "../../../user/app/browser"+("/"+browser)+".nix") # default browser selected from flake
              ../../user/app/virtualization/virtualization.nix # virtual machines
              ../../user/app/flatpak/flatpak.nix # flatpaks
              ../../user/style/stylix.nix # styling and themes for my apps
              ../../user/lang/cc/cc.nix # C and C++ tools
              ../../user/lang/godot/godot.nix # game development
              # ../../user/pkgs/blockbench.nix # blockbench
              ../../user/hardware/bluetooth.nix # bluetooth
            ];

  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core
    alacritty
    firefox
    chrome
    dmenu
    rofi
    git
    syncthing

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
    # The following requires 64-bit FL Studio (FL64) to be installed to a bottle
    # With a bottle name of "FL Studio"
    (pkgs.writeShellScriptBin "flstudio" ''
       #!/bin/sh
       if [ -z "$1" ]
         then
           bottles-cli run -b "FL Studio" -p FL64
           #flatpak run --command=bottles-cli com.usebottles.bottles run -b FL\ Studio -p FL64
         else
           filepath=$(winepath --windows "$1")
           echo \'"$filepath"\'
           bottles-cli run -b "FL Studio" -p "FL64" --args \'"$filepath"\'
           #flatpak run --command=bottles-cli com.usebottles.bottles run -b FL\ Studio -p FL64 -args "$filepath"
         fi
    '')
    (pkgs.makeDesktopItem {
      name = "flstudio";
      desktopName = "FL Studio 64";
      exec = "flstudio %U";
      terminal = false;
      type = "Application";
      mimeTypes = ["application/octet-stream"];
    })

    # Media
    gimp-with-plugins
    pinta
    krita
    inkscape
    musikcube
    vlc
    mpv
    yt-dlp
    #freetube
    blender
    #blockbench-electron
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

    # Various dev packages
    texinfo
    libffi zlib
    nodePackages.ungit
  ];

  services.syncthing.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Images";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Projects";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
      XDG_VM_DIR = "${config.home.homeDirectory}/Machines";
      XDG_ORG_DIR = "${config.home.homeDirectory}/Org";
      XDG_PODCAST_DIR = "${config.home.homeDirectory}/Media/Podcasts";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
    };
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = {
    "application/octet-stream" = "flstudio.desktop;";
  };

  home.sessionVariables = {
    EDITOR = editor;
    SPAWNEDITOR = spawnEditor;
    TERM = term;
    BROWSER = browser;
  };

}
