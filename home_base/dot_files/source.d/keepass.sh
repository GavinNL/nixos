CLOUD=pcloud
RCLONE_CLOUD_PATH=$CLOUD:/Passwords
RCLONE_CLOUD_PATH_LATEST=$RCLONE_CLOUD_PATH/latest.kdbx
PASSWORD_CACHE=$HOME/Documents/${HOSTNAME}_latest.kdbx


function checksum()
{
    md5sum $1 | awk '{print $1}'
}


function gnl_keepass_checksum()
{
   rclone copyto ${RCLONE_CLOUD_PATH_LATEST} /tmp/$USER.pcloud.latest.kdbx
   rclone copyto proton:/Password_Database/latest.kdbx /tmp/$USER.proton.latest.kdbx

   checksum /tmp/$USER.pcloud.latest.kdbx
   checksum /tmp/$USER.proton.latest.kdbx

   rm /tmp/$USER.pcloud.latest.kdbx
   rm /tmp/$USER.proton.latest.kdbx
}


function gnl_keepass()
{
   if [[ "$(which rclone)" == "" ]]; then
      echo "Rclone not installed"
      return 1
   fi

   if [[ "$(which keepassxc)" == "" ]]; then
      echo "keepassxc not installed"
      return 1
   fi

   if [[ "$(rclone listremotes | grep pcloud | wc -l)" != "1" ]]; then
      echo rclone remote, pcloud does not exist
      return 1
   fi

   if [[ ! -f  ${PASSWORD_CACHE} ]]; then
      echo ${PASSWORD_CACHE} does not exist. Downloading from ${RCLONE_CLOUD_PATH_LATEST}
      rclone copyto ${RCLONE_CLOUD_PATH_LATEST}  ${PASSWORD_CACHE}
   fi


   initialChecksum=$(checksum $PASSWORD_CACHE)
   echo Initial Checksum: $initialChecksum

   keepassxc $PASSWORD_CACHE

   finalChecksum=$(checksum $PASSWORD_CACHE)
   echo Initial Checksum: $finalChecksum


    if [[ "${initialChecksum}" != "${finalChecksum}" ]]; then

        newFileName=$(date +%Y_%m_%d_%H_%M_%S).kdbx

        tmpFolder=$(mktemp -d)

        cp ${PASSWORD_CACHE} ${tmpFolder}/${newFileName}

        echo "File has changed, we need to upload: /tmp/${newFileName} to ${RCLONE_CLOUD_PATH}"

        echo " Uploading ${tmpFolder}/${newFileName} --> ${RCLONE_CLOUD_PATH}/${newFileName}"
        rclone copyto ${tmpFolder}/${newFileName}   ${RCLONE_CLOUD_PATH}/${newFileName}

        mkdir ${tmpFolder}/redownload
        echo " Downloading pcloud:${WEBDAV_PASSWORDS_FOLDER_PATH}/${newFileName} --> ${tmpFolder}/redownload "
        rclone copyto  ${RCLONE_CLOUD_PATH}/${newFileName}   ${tmpFolder}/redownload.kdbx

        postDownloadChecksum=$(checksum ${tmpFolder}/redownload.kdbx)
        
        echo " Downloaded checksum ${postDownloadChecksum}"
        
        if [[ "${finalChecksum}" != "${postDownloadChecksum}" ]]; then  
            echo "Checksum of modified database is not the same as the checksum of the uploaded database. Something went wrong!"
        else 

            echo "Database uploaded and checked successfully"

            echo "Copying ${RCLONE_CLOUD_PATH}/${newFileName} -> ${RCLONE_CLOUD_PATH_LATEST}"
            rclone copyto ${RCLONE_CLOUD_PATH}/${newFileName}   ${RCLONE_CLOUD_PATH_LATEST}

            echo "Copying ${RCLONE_CLOUD_PATH}/${newFileName} -> proton:/Password_Database/${newFileName}"
            rclone copyto ${RCLONE_CLOUD_PATH}/${newFileName}   proton:/Password_Database/${newFileName}

            echo "deletefile proton:/Password_Database/latest.kdbx"
            rclone deletefile proton:/Password_Database/latest.kdbx

            echo "Copying ${RCLONE_CLOUD_PATH}/${newFileName} -> proton:/Password_Database/latest.kdbx"
            rclone copyto ${RCLONE_CLOUD_PATH}/${newFileName}   proton:/Password_Database/latest.kdbx

            rm -rf ${tmpFolder}
        fi

    fi
}
