#!/bin/bash

echo
echo '###################################################'
echo
echo "███████╗██╗  ██╗███████╗██╗  ██╗██╗   ██╗███████╗";
echo "██╔════╝╚██╗██╔╝██╔════╝██║  ██║██║   ██║██╔════╝";
echo "█████╗   ╚███╔╝ ███████╗███████║██║   ██║█████╗  ";
echo "██╔══╝   ██╔██╗ ╚════██║██╔══██║██║   ██║██╔══╝  ";
echo "███████╗██╔╝ ██╗███████║██║  ██║╚██████╔╝██║     ";
echo "╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     ";
echo "                                                 ";
echo " because... let's face it -- tor exit nodes suck.";
echo '###################################################'

echo -e " ProxUP ~ exitHopOR ~ The Exit Node Savior 
Sleep deprivation ... I couldn't decide on a name. "		


dynamic_Connect(){

if [[ -z "$host" ]] ; then
  . ~/.exshuf/hosts || (echo 'Host file not found: ~/.exshuf/hosts';exit 1)
  IFS=' '
  proxhosts=($proxhosts)
  num_hosts=${#proxhosts[*]}
  echo ${proxhost[$((RANDOM%num_hosts))]}
  host=${proxhosts[$RANDOM % ${#proxhosts[@]} ]}
fi
  echo "Attempting to establish tunnel to $host ..."
  "$ssh_bin" -2 -C -o IdentitiesOnly=yes -fND $dport $host &&\
  echo 'Success!'   ||\
  (echo 'ERROR... try again \(ctrl+c to abort...\)';unset host
  return 1)

}

# source config
. ~/.exshuf/config || (echo 'Config file not found: ~/.exshuf/config';exit 1)
ssh_proc="$ssh_bin"
# Check to make sure you read the config file
if [[ "$iDidntReadTheConfigFile" ]] ; then
  echo 'READ THE CONFIG FILE FIRST!'
  echo "run $ vi ~/.exshuf/config"
fi

# Confirm non-tor (prevent env attacks? idfk..)
if [[ "$non_tor" == "seriously_yeah_dude" ]] ; then
  echo "Are you sure you know what you're doing? "
  read -p "Type any key if so..."
exit 1
fi

# Confirm whonix-mode is off because we need to use a socks client if so
if [[ $whonix_mode == 'false' ]] ; then
  read -p "WARNING! Whonix mode is OFF! Did you intend for this (type \"yes\" if so)?" wnoffforrael
  if [[ "$wnoffforrael" == 'yes' ]] ; then
    _ssh_bin="$(which ssh)"
    ssh_bin="$proxy_bin $_ssh_bin"
    echo 'INFO: Whonix mode is off...'
    echo "NOTICE: ssh command is set to $ssh_bin ..."
  else
    echo 'Audit your system! BAILING!'
    exit 1
   fi
fi
#####################################################

case "$1" in
-r|--refresh)
if kill $(pgrep -f "/usr/local/sbin/ssh-proxy -2 -C -o IdentitiesOnly=yes -fND $dport") ; then
  if [[ "$?" -eq "0" ]] ; then
    echo "Killed old proxy, starting a new one..."
  else
    echo 'No proxy running, starting one...'
  fi
fi

while true;do
  dynamic_Connect && break
done

;;

-k|-kill)
echo "Killings pids... "
killall "$ssh_proc"
;;

-s|--server)
host="$2"
dynamic_Connect -r
;;

-l)
funx="$2"
echo "Running custom function $funx"
$funx
;;


-h|--help)
echo 'ExShuf - Proxup Version 1.3'
echo '----------------------------'
echo "Info: First you must hack a bunch of linux servers. Sorry, but that is beyond the     "
echo "scope of --help. Install tor ssh hidden services on all of the hosts, configure"
echo "your .ssh/config accordingly. Set proxy settings in firefox, use proxychains, socat "
echo  "or whatever you need to do. Make sure you are using ssh keys. " 
echo '----------------------------'                                                         
echo "Add hosts you want to use as your exits to the proxhosts variable and run."
echo "Usage: proxup : loadall"
echo "       proxup <-s/--server> <host> : use this specific host, don't randomize"
echo "       proxup <-l> <function> : load and run this custom function from config file"
echo "       proxup <-r/--refresh> : grab a new proxy and run on $dport"
echo "       proxup <-h/--help> you know what this does"
;;

*)

dynamic_Connect

;;
esac
exit
