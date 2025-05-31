# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # NisOS:
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"];

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.gavin = {
        isNormalUser = true;
        description = "Gavin";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
        #  thunderbird
        ];
    };

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Install firefox.
    programs.firefox.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;


    # A post activation script that will run after the system 
    # has been built
    system.activationScripts.text = ''
    ln -sf ${pkgs.bash}/bin/bash /bin/bash
    ln -sf ${pkgs.bash}/bin/bash /usr/bin/bash
    '';

    #=============================================================================
    # This is for use with atuin
    #
    # Atuin requires your bash shell to source some files for it to work properly
    # so we are going to download the files to /etc
    # 
    # and then ahve the /etc/bashrc.local (generated manually) source
    # them
    #=============================================================================
    environment.etc."bash-preexec.sh".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/rcaloras/bash-preexec/refs/tags/0.5.0/bash-preexec.sh";
    sha256 = "bvlfFgEr3+wKtu6FPoiS1R7uKVyGOZRPm5g7PUDg6fc=";  # Replace this with the correct hash
    };

    environment.etc."atuin.bash".source = pkgs.runCommand "atuin-init-bash" { } ''
    # "atuin init bash" needs access to a home directory
    #  but since we are running this script as a root user with no home directory
    #  we need to make one temporarly
    export HOME="${builtins.toString ./temp-home}";
    ${pkgs.atuin}/bin/atuin init bash --disable-up-arrow > $out
    '';
    #=============================================================================


    #=============================================================================
    # Generate a bashrc.local that will be sourced when an interactive bash 
    # shell is launched 
    #=============================================================================
    environment.etc."bashrc.local".text = ''
    # Used for Atuin
    source /etc/bash-preexec.sh
    source /etc/atuin.bash
    '';
    #=============================================================================


    #=============================================================================
    # Fuse configuration 
    #=============================================================================
    environment.etc."fuse.conf".text = ''
    # Allow non-root users to specify the allow_other or allow_root mount options.
    user_allow_other

    # Uncomment to allow root users to specify the allow_other mount option.
    allow_other

    # Enable maximum number of FUSE mounts allowed per user
    mount_max = 1000
    '';
    #=============================================================================

    #=============================================================================
    # Virtualization via docker/podman
    #=============================================================================
    virtualisation = {

      containers = {
          enable = true;
      };

      podman = {
          enable = true;

          # Create a `docker` alias for podman, to use it as a drop-in replacement
          # dockerCompat = true;

          # Required for containers under podman-compose to be able to talk to each other.
          defaultNetwork.settings.dns_enabled = true;
      };

      docker = {
          enable = true;
      };
    };
    #=============================================================================

    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
        nerd-fonts._0xproto
        nerd-fonts.droid-sans-mono
    ];

  environment.systemPackages = with pkgs; [
    # Command line Text editors
    nano
    micro
    vim
    curl
    wget
    coreutils      # Basic Linux utilities
    findutils      # find and related utilities
    gnused         # sed
    gnugrep        # grep
    procps         # ps, top, etc.
    util-linux     # Includes various useful tools like mount, fdisk, etc.
    bash           # Bash shell if not included by default
    man             # Man pages
    git             # Git version control tool
    pciutils
    openssl
    usbutils
    gnupg
    libnotify
    htop
    lm_sensors
    psmisc
    entr            # File changes
    xclip
    jq       
    tldr
    fuse
    fuse3
    fuse-overlayfs
    xxd
    xorg.xkill
    tree
    neofetch
    fastfetch
    rclone
    wireguard-tools
    tmate # share your terminal via the web      
    sshfs
    ncdu
    keepassxc
    tilix

    # Fixes some erros with glib
    gvfs
    glib
    
    btrfs-progs

    socat 
    mitmproxy

    atuin
    #unstablePkgs.atuin 
    #unstablePkgs.brave

    # Python
    python3
    python311Packages.pip
    pyenv

    # Containerization
    distrobox 
    podman
    podman-compose
    docker-compose
  ];# ++ config.environment.systemPackages;

}
