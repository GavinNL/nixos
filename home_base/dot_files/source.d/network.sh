#######################################################################################
# Configuration variables
#######################################################################################
HOME_TUNNEL_SSH="gavin@api.gavs.space -p 60111"

# Local port where the ssh tunnel will be created
HOME_TUNNEL_LOCAL_PORT=${HOME_TUNNEL_LOCAL_PORT:-9090}
#######################################################################################

alias gnl_geolookup='curl -s http://ip-api.com/json/$(curl -s ifconfig.me) | jq'

function gnl_list_connections_on_port {
    lsof -nP -i TCP:$1
}

#######################################################################################
# Create a SSH socks5 socket and let your browser
# connect through that
#
# Usage: Open Two terminals
#     terminal 1: home_tunnel
#     terminal 2: home_browser
#######################################################################################
gnl_home_tunnel() {
    ssh -N -D ${HOME_TUNNEL_LOCAL_PORT} ${HOME_TUNNEL_SSH}
}

gnl_home_browser() {
    brave-browser --user-data-dir="$CACHE_FOLDER/brave-tunnel" --proxy-server="socks5://localhost:${HOME_TUNNEL_LOCAL_PORT}"
}
#######################################################################################
