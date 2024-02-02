{ config, pkgs, ... }: 

{
  # Terminal Tools
  environment.systemPackages = with pkgs; [
    # core
    zoxide # better cd
    lsd # better ls
    bat # better cat
    mdcat # cat markdown
    viu # view images
    tre-command # better tree
    chafa # approximate images (very well)
    
    # meta
    progress # check progress of core unix commands
    noti # notify user on command completion
    tealdeer # command guides
    mcfly # terminal history

    # network
    gping
    wget
    curl
    aria
    xh # send http requests
    git
    gh
    # lazy-git # git tui
    # git-ignore # fetch .gitignore templates from gitignore.io

    # files
    skim # fuzzy file search
    fd # find files by name
    ripgrep-all # regex search
    sd # search and replace
    ouch # file compression
    monolith # save whole webpages to disk
    trash-cli # terminal trashcan

    # multimedia
    imagemagick # cli for image processing
    gifsicle # cli for gif processing
    ffmpeg # cli for video processing

    # development
    # just # save and run project-specific commands
    # xxh # bring shell environment with you over ssh
    # tokei # count loc

    # maintenance
    btop
    bottom # system monitor
    topgrade
    du-dust # tree of large files
    psmisc # process tools
  ]
}