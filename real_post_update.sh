#!/bin/sh
#
# An example hook script to prepare a packed repository for use over
# dumb transports.
#
# To enable this hook, make this file executable by "chmod +x post-update".

echo "post-update hook: update kodos working directory (never work there!)"
cd ..
unset GIT_DIR

#POST to IRC, e.g. 
/home/git/post_update.sh

#reset local working directory
git reset --hard HEAD
git checkout -f

#exec git-update-server-info
