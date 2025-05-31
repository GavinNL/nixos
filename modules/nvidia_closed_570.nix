# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstablePkgs, ... }:

let
  unstable = import <unstable> { inherit (pkgs) system; };
in
{
    #============================================================================
    # Graphics and Drivers
    #============================================================================
    # Enable OpenGL
    hardware.graphics = {
        enable = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    # Allows passing nvidia cards into podman/docker containers
    hardware.nvidia-container-toolkit.enable = true;
    hardware.nvidia = {

        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
        # of just the bare essentials.
        powerManagement.enable = false;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of 
        # supported GPUs is at: 
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
        # Only available from driver 515.43.04+
        open = false;

        # Enable the Nvidia settings menu,
	    # accessible via `nvidia-settings`.
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.

        #####################################################################################
        # Use the stable driver: 565 as of Feb 2025
        #package = config.boot.kernelPackages.nvidiaPackages.stable;
        #####################################################################################
        # Manually build the driver for Version 570
        #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #    version = "570.124.04";
        #    # These values are correct
        #    sha256_64bit = "sha256-G3hqS3Ei18QhbFiuQAdoik93jBlsFI2RkWOBXuENU8Q=";
        #    settingsSha256 = "sha256-LNL0J/sYHD8vagkV1w8tb52gMtzj/F0QmJTV1cMaso8=";
        #    persistencedSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
        #
        #    # Not sure what these are??
        #    sha256_aarch64 = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
        #    openSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
        #};
        #####################################################################################
        #####################################################################################
        # Manually build the driver for Version 570
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
            version = "570.153.02";
            # These values are correct
            sha256_64bit = "sha256-FIiG5PaVdvqPpnFA5uXdblH5Cy7HSmXxp6czTfpd4bY=";
            settingsSha256 = "sha256-LNL0J/sYHD8vagkV1w8tb52gMtzj/F0QmJTV1cMaso8=";
            persistencedSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
        
            # Not sure what these are??
            sha256_aarch64 = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
            openSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
        };
        #####################################################################################
    };
    #============================================================================

}
