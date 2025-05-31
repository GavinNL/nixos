
# Mounts one of the rclone cloud end points
# Best one to use is:
#    gnl_mount_cloud storage
gnl_mount_cloud() {
    name="$1"
    MNT_PATH=$2

    if [[ "$(rclone listremotes | grep $1 | wc -l)" == "1" ]]; then
        MNT_FOLDER=$HOME/.local/mnt

        if [[ "$MNT_PATH" == "" ]]; then
            MNT_PATH=$MNT_FOLDER/$name
        fi


        mkdir -p $MNT_PATH
        
        if [ "$(stat -c %d $MNT_PATH)" != "$(stat -c %d $MNT_PATH/..)" ]; then

          echo "$MNT_PATH is a mount point"

        else

          rclone cmount $name:/  $MNT_PATH  --daemon --vfs-cache-mode full

        fi
    fi
}

gnl_unmount_cloud() {

    name="$1"

    if [[ "$(rclone listremotes | grep $1 | wc -l)" == "1" ]]; then
        MNT_FOLDER=$HOME/.local/mnt
        MNT_PATH=$MNT_FOLDER/$name
        fusermount -u $MNT_PATH 
    fi
}
