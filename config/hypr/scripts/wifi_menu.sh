#!/bin/sh

# function to run command as root using sudo password
function SUDO() {
    sudo -S $@ <<< "$pw"
}

# get sudo password using bemenu and check if password is correct
pw="$(bemenu --password --prompt "sudo password: " <<< "")" 
SUDO whoami
if [ "$?" != "0" ] ; then
    notify-send "Error: could not authenticate using sudo!"
    exit 1
fi

# get current network
current="$(SUDO wpa_cli status | awk -F "=" '/^ssid=/ {print $2; exit}')"

# read network IDs and then get each network's SSID
# and put that into $networks using this format ID:SSID
networks=""
while IFS= read -r id;
do 
    networks="$id:$(SUDO wpa_cli get_network "$id" ssid | awk '/^".*?"$/' | tr -d '"')\\n$networks"
done <<< "$(SUDO wpa_cli list_networks | awk '/^[0-9]/ {print $1}' | sort -r)"

# get network input from user (and filter out current one)
network="$(printf "$networks" | grep -v "$current" | bemenu --prompt "$current ->")"

# cut up selected network string using cut
id="$(cut -d ":" -f1 <<< "$network")"
ssid="$(cut -d ":" -f2 <<< "$network")"

# set selected network wih wpa_cli
SUDO wpa_cli select_network "$id"
if [ "$?" != "0" ] ; then
    notify-send "There was an error connecting to '$network'!"
else
    notify-send "Selecting network $ssid!"
fi

sleep 5s

if [ "$(SUDO wpa_cli status | grep state | cut -d"=" -f2)" != "COMPLETED" ] ; then
    notify-send "Network '$ssid' failed to connect after 5 seconds!"
fi
