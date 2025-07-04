{
  description = "My Multi-Host NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";  # Stable
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";  # Unstable

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, hyprpanel, nixpkgs, unstable, ... } @ inputs :
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.amazo = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { 
            inherit inputs; 
        };
        modules = [
          ./amazo/amazo.nix
          ./common/common.nix

          ################################################
          # Modules for specific desktop
          # environments. Can enable to disable
          # as many of these as you want  
          ################################################
          ./modules/desktop_cinnamon.nix
          ./modules/desktop_cosmic.nix
          ./modules/desktop_niri.nix
          ./modules/hyprland_official.nix
          ################################################

          ################################################
          # Choose only one of the following
          # depending on what version of driver you 
          # need   
          ################################################
          ./modules/nvidia_closed_570.nix
          ################################################

          ################################################
          # Creates an rclone mount point at /mnt/storage
          # for gavin's rclone conf. /home/gavin/.rclone.conf 
          #  must exist  
          ################################################
          ./modules/cloud_mount.nix
          ################################################

          ./modules/steam.nix  
        ];
        #specialArgs = {
        #  unstablePkgs = unstable.legacyPackages.${system};
        #};
      };
    };
}
