#######################################################################################
FILE_LOCATION="${BASH_SOURCE[0]}"
while [ -h "$FILE_LOCATION" ]; do # resolve $FILE_LOCATION until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$FILE_LOCATION" )" >/dev/null 2>&1 && pwd )"
  FILE_LOCATION="$(readlink "$FILE_LOCATION")"
  [[ $FILE_LOCATION != /* ]] && FILE_LOCATION="$DIR/$FILE_LOCATION" # if $FILE_LOCATION was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

SOURCE_DIR="$( cd -P "$( dirname "$FILE_LOCATION" )" >/dev/null 2>&1 && pwd )"
#######################################################################################


#################################C######################################################
# Configuration variables
#######################################################################################
#CACHE_FOLDER=${CACHE_FOLDER:-${SOURCE_DIR}/../../.CACHE}
#CACHE_FOLDER=$(realpath $CACHE_FOLDER)
CACHE_FOLDER=$HOME/.config/BraveSoftware
#######################################################################################


#######################################################################################
_firefox_profile() {
PROFILEDIR=$CACHE_FOLDER/firefox-$1-data
mkdir -p $PROFILEDIR
firefox -profile $PROFILEDIR -no-remote -new-instance
}

#######################################################################################

#######################################################################################
# Start the brave browser but use different data-directories for each
# for each service you are planning on using. This is so there is no
# cookies or other information shared between sites that are known
# to steal data
#######################################################################################
_brave() {
    if [[ ! -e ${CACHE_FOLDER} ]]; then
         mkdir ${CACHE_FOLDER}
    fi

    bin_="brave"
    if [[ ! $(which brave-browser-nightly) = "" ]]; then
        bin_="brave-browser-nightly"
    fi

    ${bin_} --user-data-dir="$CACHE_FOLDER/brave-$1-data"
}

gnl_workbrave() {
    _brave work
}

gnl_googlebrave() {
    _brave google
}

gnl_tempbrave() {
    if [[ ! -e ${CACHE_FOLDER} ]]; then
         mkdir ${CACHE_FOLDER}
    fi
    bin_="brave"
    if [[ ! $(which brave-browser-nightly) = "" ]]; then
        bin_="brave-browser-nightly"
    fi

    rm -rf $CACHE_FOLDER/brave-temp-data
    $bin_ --incognito --user-data-dir="$CACHE_FOLDER/brave-temp-data"
    rm -rf $CACHE_FOLDER/brave-temp-data
}

alias bankbrave='_firefox_profile bank'
#######################################################################################


