#!/bin/bash

MAINDIR=${PWD##*/}
AUTHOR=`git log -1 --branches --pretty="format:%an" |awk '{print $1}'`
REV=`git log -1 --branches --pretty="format:%h"`
REV_LINE=`git log --branches --pretty=oneline -1 --abbrev-commit`

/home/git/irc_post.sh ${MAINDIR} ${AUTHOR} "${REV_LINE}"
#irc_post.sh will look something like this 
# (we have an eggdrop bot which has white-listed our git server) 
# echo echo -e \"${USER}\\n${PASSWORD}\\n.say GIT: ${AUTHOR} ${MAINDIR} ${REV_LINE}\"|bash |nc -i1 -q0 ${SERVER} ${PORT} &>/dev/null