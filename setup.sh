#!/bin/bash
source endpoints.conf #get the config

#empty first [if exists], remake and cd
rm -r "./${SHADOW}" 
mkdir "${SHADOW}"
cd "${SHADOW}" 

#trap AFTER cd as we rm ./*; trap exit(0)
#ignore sighup(1),sigterm(15),sigint(2,Ctrl+C)
#don't need to "exit 1" but ${1} might allow codes
#using exit in an EXIT trap does not recurse, else it would be infinite
trap 'rm ./*' EXIT

#fetch each of the static files
for ((i=0; i<${#STATICS[@]}; ++i)); do
  wget "${SERVER}${STATICS[$i]}"
done

#(no rm on remote - $REMOTE contains scp path and cannot ssh to rm)
#copy and rm local (rm is EXIT signal/cleanup)
scp -P ${REMOTE_PORT} ./* "${REMOTE}"
