#!/bin/bash

cd ~git/
 
# Any directories with a .svn extension will get rebased and then push to the github remote location
# see
for r in *.svn;
  do cd $r;
    echo REPOSITORY $r
    git svn rebase
    if (git remote|grep '^github$') ;then
	git pull github master #sometimes necessary to sync changes
	git push github master
    fi
    cd ..
done;

for g in *.git;
  do cd $g;
    echo REPOSITORY $g
    if (git remote|grep '^github$') ;then
	git pull github master
	git push github master
    fi
    cd ..
done;

#for bvault bzr->svn
#for b in *.bzr;
#  do cd $b;
#  svn update
#  bzr merge --force
#  find . -not -regex '.*\.\(svn\|bzr\).*' -exec svn add '{}' \;
#  svn ci -m'auto update from launchpad source'
#  cd ..;
#  done;