#!/bin/bash

STATICS=(Ranking.html styles.css utilities.js CurrentTime.js Practice_Schedule_Overview.html Practice_Current_Schedule.html Ranking_Schedule_Overview.html Ranking_Current_Schedule.html GetSponsorLogos)

source server-remote.sh #get the config

rm -r "./${SHADOW}"
mkdir "${SHADOW}"
cd "${SHADOW}"

for ((i=0; i<${#STATICS[@]}; ++i)); do
  wget "${SERVER}${STATICS[$i]}"
done

#clear it yourself, no rm cmds on remote
###ssh "${REMOTE}" 'rm -r ./*'
scp ./* "${REMOTE}"
rm ./*
