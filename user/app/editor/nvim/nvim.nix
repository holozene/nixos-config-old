{ config, lib, pkgs, ... }:

{
  # Module installing neovim as default 
  home.packages = [ pkgs.vim pkgs.neovim ];

  

}
