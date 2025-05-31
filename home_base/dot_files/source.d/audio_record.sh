##################
function get_name_of_sink {
   pacmd list-sinks | grep 'name:' | cut -c9-999 | rev | cut -c2-999 | rev | head -n $1 | tail -n 1
}

# Lists all audio sinks
function list_all_sinks {
   pacmd list-sinks | grep 'name:' | cut -c9-999 | rev | cut -c2-999 | rev
}

# Get a dialog of available sinks to choose one.
function select_sink {
   dialog --menu "Choose one:" 15 50 5 $(list_all_sinks | cat -n | tr '\n' ' ') --output-fd 1
}



function gnl_wav_to_mp3 {
   ffmpeg -i $1  -vn -ac 2 -ab 192k -f mp3 $2
}



echoerr() { echo "$@" 1>&2; }

function gnl_record_audio {
   M=$(select_sink)

   filename=$HOME/Music/record_$(date +%s).wav

   echoerr Recording audio to $filename. Press ctrl-C to stop.

   parec -d $(get_name_of_sink $M).monitor --file-format=wav $filename

   gnl_wav_to_mp3 $filename ${filename}.mp3

   rm $filename

}

function gnl_set_bpm {
    eyeD3 --bpm=$2 "$1"
}
