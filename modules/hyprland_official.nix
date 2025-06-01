# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    hyprland
    hyprlandPlugins.hyprbars
    hyprlandPlugins.hyprexpo
    rofi-wayland
    waybar
    hyprshot
    hyprcursor
    hyprpaper
    hyprlock
    hypridle
    mako
    libnotify
    networkmanagerapplet
    starship
    kitty
    nwg-look
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

}
