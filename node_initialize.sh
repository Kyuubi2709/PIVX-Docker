#!/usr/bin/env bash

function get_ip() {

    WANIP=$(curl --silent -m 15 https://api4.my-ip.io/ip | tr -dc '[:alnum:].')

    if [[ "$WANIP" == "" ]]; then
      WANIP=$(curl --silent -m 15 https://checkip.amazonaws.com | tr -dc '[:alnum:].')
    fi

    if [[ "$WANIP" == "" ]]; then
      WANIP=$(curl --silent -m 15 https://api.ipify.org | tr -dc '[:alnum:].')
    fi
}

get_ip
RPCUSER=$(pwgen -1 18 -n)
PASSWORD=$(pwgen -1 20 -n)

if [[ -f /root/.blocx/blocx.conf ]]; then
  rm  /root/.blocx/blocx.conf
fi

touch /root/.blocx/blocx.conf
cat << EOF > /root/.blocx/blocx.conf
rpcuser=$RPCUSER
rpcpassword=$PASSWORD
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
txindex=1
znode=1
externalip=$WANIP:12972
znodeblsprivkey=$KEY
EOF

while true; do
blocxd -daemon
sleep 60
done