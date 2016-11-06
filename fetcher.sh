#!/bin/bash

PAGES=(Get_Team_Ranking_Web Time_Control\?Action\=2 Serve_Team_Data Get_Game_Title Get_Num_Rounds_To_Show Serve_Schedules)
# Serve_Current_Time dyn-gen

#PCOUNT= #array-len

source server-remote.sh #get the config
#shadow folder for diffs
#run in current folder

fetch_send() {
  #Query String Page == QSP
  qsp=${1}
  page=$(echo "${qsp}" | sed -E 's/^([^?]+)(\?[^?]*)?$/\1/')
  
  #get,diff,scp,move
  #get expect 0true, diff expect 1false, scp expect 0, mv expect 0
  #IN BASH, && and || have EQUAL PRECEDENCE, LTR EVALUATION
  #CHAINED COMMANDS REQUIRE PREVIOUS TO SUCCEED
  { wget -t 1 "${SERVER}${qsp}" -O "${page}" &&
    diff -q "${page}" "${SHADOW}${page}" || 
    scp "${page}" "${REMOTE}" &&
    mv "${page}" "${SHADOW}"
  }
  
  #clean
  if [ -e "${page}" ]; then rm "${page}"; fi
}

while : ; do
  for ((i=0; i<${#PAGES[@]}; ++i)); do
    fetch_send "${PAGES[$i]}"
  done
done
