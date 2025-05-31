#######################################################################################
FILE_LOCATION="${BASH_SOURCE[0]}"
while [ -h "$FILE_LOCATION" ]; do # resolve $FILE_LOCATION until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$FILE_LOCATION" )" >/dev/null 2>&1 && pwd )"
  FILE_LOCATION="$(readlink "$FILE_LOCATION")"
  [[ $FILE_LOCATION != /* ]] && FILE_LOCATION="$DIR/$FILE_LOCATION" # if $FILE_LOCATION was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

SOURCE_DIR="$( cd -P "$( dirname "$FILE_LOCATION" )" >/dev/null 2>&1 && pwd )"
#######################################################################################


#######################################################################################
# Configuration variables
#######################################################################################
# Location where the user would manually install applcations
# using make install, or some other method.
# each  each folder in $PREFIX_FOLDER/install_name/bin which exists
# will be added to the PATH 
# 
export GNL_PREFIX_FOLDER=${GNL_PREFIX_FOLDER:-$HOME/Apps}


#######################################################################################
# Automatic adding of folders to your path
#  
# Sometimes when you download linux packages in the form of tar balls or self extracting
# scripts, they have the following folders APP_NAME/{bin,lib,share,...}
# and they are meant to be extract to your / folder so that the binaries and libs
# end up in the correct location
#
# This polutes your root folder, so intead, you can install it to $PREFIX_FOLDER/APP_NAME
# and this script will automatically loop through all the APP prefixes in the $PREFIX_FOLDER
# and add the bin folder to the END of your PATH.
#
# Try it with Cmake: https://github.com/Kitware/CMake/releases/download/v3.20.5/cmake-3.20.5-linux-x86_64.tar.gz
#
#######################################################################################
PREFIX_PATHS=""
for dir in $GNL_PREFIX_FOLDER/*; do
    if [ -d "$dir/bin" ]; then
      PREFIX_PATHS=$PREFIX_PATHS:${dir}/bin
    fi
done
export PREFIX_PATHS
export PATH=$PATH:$PREFIX_PATHS
#######################################################################################

