{ config, lib, pkgs, stdenv, fetchurl, nix-doom-emacs, stylix, username, email, dotfilesDir, theme, wm, browser, editor, spawnEditor, term, keymap, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/"+username;

  programs.home-manager.enable = true;
  home-manager.useUserPackages = true;

  imports = [
              ../../user/hardware/bluetooth.nix # bluetooth
              (./. + "../../../user/wm/"+wm+"/"+wm+".nix") # window manager selected from flake
              # todo: implement `if (keymap != "") then ...` to support using `keymap = "";` in flake 
              (./. + "../../../user/keymap/"+keymap+".nix") # keymap selected from flake
              stylix.homeManagerModules.stylix
              ../../user/style/stylix.nix # styling and themes for my apps
              ../../user/app/git/git.nix # git config
              ../../user/shell/sh.nix # zsh
              ../../user/shell/cli-collection.nix # useful CLI apps
              ../../user/bin/phoenix.nix # nix command wrapper
              nix-doom-emacs.hmModule
              ../../user/app/ranger/ranger.nix # ranger file manager config
              # ../../user/app/keepass.nix # password manager
              (./. + "../../../user/app/browser/"+browser+".nix") # default browser selected from flake
              ../../user/app/virtualization/virtualization.nix # virtual machines
              ../../user/app/flatpak/flatpak.nix # flatpaks
              ../../user/lang/cc/cc.nix # C and C++ tools
            ];

  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core
    alacritty
    firefox
    chromium
    dmenu
    rofi
    git
    syncthing
    mpv

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

  home.sessionVariables = {
    EDITOR = editor;
    SPAWNEDITOR = spawnEditor;
    TERM = term;
    BROWSER = browser;
  };

}
