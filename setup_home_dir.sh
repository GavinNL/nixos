#!/usr/bin/env bash
#######################################################################################
FILE_LOCATION="${BASH_SOURCE[0]}"
while [ -h "$FILE_LOCATION" ]; do # resolve $FILE_LOCATION until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$FILE_LOCATION" )" >/dev/null 2>&1 && pwd )"
  FILE_LOCATION="$(readlink "$FILE_LOCATION")"
  [[ $FILE_LOCATION != /* ]] && FILE_LOCATION="$DIR/$FILE_LOCATION" # if $FILE_LOCATION was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

SOURCE_DIR="$( cd -P "$( dirname "$FILE_LOCATION" )" >/dev/null 2>&1 && pwd )"
#######################################################################################

# Where all the users files are going to be stored
# the Pictures/Documents/Videos/etc folders will be here
ACTUAL_HOME=${SOURCE_DIR}/home


HOMEBASE=$HOME/.nixos

HOME_FOLDERS=${HOMEBASE}/home_base/home
DOT_FILES=${HOMEBASE}/home_base/dot_files
CONFIG_FOLDERS=${HOMEBASE}/home_base/config

# Symlinks will be stored here. This should normally be set to
# /home/USERNAME
#
HOME=$HOME


if [[ ! -f $HOMEBASE/setup_home_dir.sh || ! -d $HOMEBASE/.git ]]; then
    echo "This git repo must exist at $HOMEBASE"
    exit 1
fi

if [[ ! $(command -v rclone) ]]; then
    echo "rclone not installed. Install it."
    exit 1
fi


if [[ ! -f $(realpath $HOME/.rclone.conf) ]]; then
    echo ".rclone.conf must exist at $HOME/.rclone.conf"
    exit 1
fi


#mkdir -p ${HOME}
#rm -rf ${HOME}/.*
#exit

mkdir -p ${HOME}/.local/bin
mkdir -p ${HOME}/.local/share
mkdir -p ${HOME}/.config
mkdir -p ${HOME}/.cache

mksymlink() {

   # The source file/folder does not exist
   if [ ! -e "$1" ]; then

         # The destination file does exist and is not a symlink
         if [[ -e "$2" && ! -L "$2" ]]; then
             # So move the destination to the source and make a symlink
             # at destination to source
             mv $2 $1
             echo "Destination file exists but source doesnt. Copying DESTINATION as SOURCE"
         else
             echo "${1} does not exist. Ignoring"
             return
         fi
   fi

   # The symlink at destination already exists
   # So remove it
   if [ -L "$2" ]; then
       echo "Symlink exists: ($2). Removing"
       rm $2
   fi

   # The destination already exists, so we're going to rename it to .old
   # so that we dont lose any data
   if [ -e "$2" ]; then
       echo "Path exists ($2). Renaming."
       mv $2 $2.old.$(date "+%s")
   fi

   ln -s $1 $2
   echo "Symlink created $1 -> $2"
}

#############
# Loop through all files in the directory
#mkdir -p ${HOME}/.local/share/applications
#for file in "${ACTUAL_HOME}/LAUNCHERS"/*; do
#    mksymlink ${file}     ${HOME}/.local/share/applications/$(basename ${file})
#done

#############

for dir in ${HOME_FOLDERS}/{*,.*/}; do
    if [ -d "$dir" ]; then
        base=$(basename $dir)
        if [[ -L ${HOME}/$base ]]; then
            rm ${HOME}/$base;
        fi
        if [[ -d ${HOME}/$base ]]; then
            mv ${HOME}/$base ${HOME}/${base}.old.$(date "+%s");
        fi
        ln -s $dir ${HOME}/$base
        echo "Found directory: $dir:  $(basename $dir)"
    fi
done

mkdir -p ${HOME}/.config
for dir in ${CONFIG_FOLDERS}/{*,.*/}; do
    if [ -d "$dir" ]; then
        base=$(basename $dir)
        if [[ -L ${HOME}/.config/$base ]]; then
            rm ${HOME}/.config/$base;
        fi
        if [[ -d ${HOME}/.config/$base ]]; then
            mv ${HOME}/.config/$base ${HOME}/${base}.old.$(date "+%s");
        fi
        ln -s $dir ${HOME}/.config/$base
        echo "Found directory: $dir:  $(basename $dir)"
    fi
done


mksymlink  ${DOT_FILES}/bash_aliases   ${HOME}/.bash_aliases
mksymlink  ${DOT_FILES}/bashrc         ${HOME}/.bashrc
#mksymlink  ${DOT_FILES}/bash_history   ${HOME}/.bash_history
mksymlink  ${DOT_FILES}/profile        ${HOME}/.profile
mksymlink  ${DOT_FILES}/gitconfig      ${HOME}/.gitconfig



exit 0
mkdir -p ${HOME}/.local/share
for dir in ${ACTUAL_HOME}/SHARE/{*,.*/}; do
    if [ -d "$dir" ]; then
        base=$(basename $dir)
        if [[ -L ${HOME}/.local/share/$base ]]; then
            rm ${HOME}/.local/share/$base;
        fi
        if [[ -d ${HOME}/.local/share/$base ]]; then
            mv ${HOME}/.local/share/$base ${HOME}/${base}.old.$(date "+%s");
        fi
        ln -s $dir ${HOME}/.local/share/$base
        echo "Found directory: $dir:  $(basename $dir)"
    fi
done

# Default Home folders
#mkdir -p ${ACTUAL_HOME}/PY_ENV




# Dot Files
#mksymlink  ${DOT_FILES}/rclone.conf    ${HOME}/.rclone.conf


if [[ "$HOSTNAME" == "amazo" ]]; then
    # User's systemd services
    mkdir -p ${HOME}/.config/systemd
    mksymlink  ${ACTUAL_HOME}/SERVICES         ${HOME}/.config/systemd/user
    mksymlink  ${ACTUAL_HOME}/SHARE/atuin      ${HOME}/.local/share/atuin

    systemctl --user daemon-reload
fi



