#!/bin/bash
source endpoints.conf #get the config

cleanup() {
  #kill the ssh tunnel if it exists
  if [ -e ssh.pid ]; then
    kill -HUP $(cat ssh.pid)
    rm ssh.pid
  fi

  #rm any remaining page copies, but keep ${SHADOW} unscathed
  for ((i=0; i<${#PAGES[@]}; ++i)); do
    page=$(echo "${PAGES[i]}" | sed -r 's/^([^?]+)(\?[^?]*)?$/\1/')
    if [ -e "${page}" ]; then rm "${page}"; fi
  done

  #no need to actually exit at the end here as we only trap exit
}
trap cleanup EXIT

#tunnel the connection so handshaking faster
if [ "${1}" = '--tunnel' ]; then
  ssh -NL 2222:localhost:${REMOTE_PORT} -p ${REMOTE_PORT} $(echo "${REMOTE}" | sed -r 's/^([^:@]+@)?([a-zA-Z0-9_\-\.]+)(:.*)?$/\1\2/') &
  echo "$!" > ssh.pid
  echo "Sleeping for 5 seconds to initiate SSH tunnel"
  sleep 5 #initialising
  REMOTE=$(echo "${REMOTE}" | sed -r 's/^([^:@]+@)?([a-zA-Z0-9_\-\.]+)(:.*)?$/\1localhost\3/')
  REMOTE_PORT=2222
fi

while : ; do
  for ((i=0; i<${#PAGES[@]}; ++i)); do

    #Query String Page == QSP
    qsp="${PAGES[$i]}"
    page=$(echo "${qsp}" | sed -r 's/^([^?]+)(\?[^?]*)?$/\1/')

    #CHAINED COMMANDS (previous must succeed) - get,diff,scp,move
    #get expect 0true, diff expect 1false, scp expect 0, mv expect 0
    #IN BASH, && and || have EQUAL PRECEDENCE, LTR EVALUATION
    { wget -nv -t 1 "${SERVER}${qsp}" -O "${page}" &&
      diff -q "${page}" "${SHADOW}${page}" ||
      scp -P ${REMOTE_PORT} "${page}" "${REMOTE}" &&
      mv "${page}" "${SHADOW}"
    }

    #cleanup
    if [ -e "${page}" ]; then rm "${page}"; fi

  done
  #sleep 0.2
done
