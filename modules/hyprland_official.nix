# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget

    hyprland
    hyprshot     # screen shot
    hyprcursor   # ??
    hyprpaper    # Set wallpapers
    hyprlock     # Lock screen
    hypridle     # Idle checking

    waybar       # Create status bar at the top of the page
    starship     # Make your terminal prompts look cool
                 # Requires adding this to your bash_rc
                 #
                 #   if command -v starship >/dev/null ; then
                 #       eval "$(starship init bash)"
                 #   fi
                 #

                 
    inputs.hyprpanel.packages.${pkgs.system}.wrapper

	swaynotificationcenter # Notifications
	walker # another app launcher
	
    # Terminal emulator
    kitty

    #hyprlandPlugins.hyprbars
    #hyprlandPlugins.hyprexpo
    libnotify

    networkmanagerapplet

    wlogout
    wl-clipboard
    pavucontrol
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

}
