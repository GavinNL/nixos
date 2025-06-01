# Following the official recommendations to 
# use Hyrpland plugins using flakes
#
#
# https://github.com/hyprwm/hyprland-plugins
#
# Error is given below:
#
{ lib, pkgs, inputs, ... }:
with lib; let
  hyprland = import <hyprland> { inherit (pkgs) system; };
  hyprPluginPkgs = inputs.hyprland-plugins.packages.${pkgs.system};
  hypr-plugin-dir = pkgs.symlinkJoin {
    name = "hyrpland-plugins";
    paths = with hyprPluginPkgs; [
      hyprexpo
      hyprbars
#      hyprpanel
      #...plugins
    ];
  };
in
{
    
  programs.hyprland.enable = true;
  environment.sessionVariables = { HYPR_PLUGIN_DIR = hypr-plugin-dir; };
}


