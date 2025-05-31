# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstablePkgs, ... }:

let
  unstable = import <unstable> { inherit (pkgs) system; };
in
{
    fileSystems."/mnt/storage" = {
        device = "storage:";
        fsType = "rclone";
        options = [
            "nodev"
            "nofail"
            "allow_other"
            "noauto"

            #"args2env"       # Arguments should be passed by env variable instead of command line

            "config=/home/gavin/.rclone.conf"
            "cache-dir=/var/rclone"
            "default-permissions"
            "uid=1000"
            "gid=100"
            "umask=077"

            "vfs-cache-mode=full"
            "transfers=16"
            "multi-thread-streams=8"
            
            # "soft"             # prevents indefinte hangs
            #"timeo=10"         # waits one second before retrying
            #"retrans=3"
            "x-systemd.automount" # mounts only when accessed
            "x-systemd.idle-timeout=600" # ensures it does not block boot if unreachable
            "x-systemd.device-timeout=2" # Maximum time to wait for the device
        ];

    };

}
