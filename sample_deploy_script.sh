#!bin/bash

# We use an internall developed deploy platform: http://github.com/ccnmtl/rollo
# which makes this easily run from the web.
# This script is an example of how to deploy from a git repo

GIT_BRANCH=$1
GIT_REMOTE=$2
REMOTE_DIRECTORY=$3
REMOTE_HOST=$4

#directory to checkout into (temporary directory)
CHECKOUT_DIR=$5

#identifier of this push, which can be used for the ROLLBACK_URL 
# if you need to redeploy a previous deployment to overwrite a bad deployment
ROLLBACK_PUSH_ID=$5
#if you are rolling back to a previous deployment, set this
ROLLBACK_URL=$6

# 1. 
# clear the checkout directory so we can do a fresh checkout
if [ "$CHECKOUT_DIR" = "" ]; then
   echo "checkout dir not set!"
else
   rm -rf $CHECKOUT_DIR
fi

# 2.
# git clone/archive
cd $CHECKOUT_DIR
cd ..
rmdir $CHECKOUT_DIR
if [ "$ROLLBACK_URL" = "" ]; then
  git clone --recursive --depth 1 $GIT_REMOTE $CHECKOUT_DIR
else
  git clone --recursive $GIT_REMOTE $CHECKOUT_DIR
  cd $CHECKOUT_DIR
  git checkout $ROLLBACK_URL
fi

# 3.
# git tag 
if [ "$ROLLBACK_URL" = "" ]; then
  cd $CHECKOUT_DIR; git config user.email "ccnmtl-pusher@example.com"
  cd $CHECKOUT_DIR; git config user.name "CCNMTL Pusher"
  cd $CHECKOUT_DIR; git tag ROLLO_PUSH_${ROLLO_PUSH_ID} -m 'tagged for push by ${PUSH_UNI}: ${PUSH_COMMENT}'
  cd $CHECKOUT_DIR; git push --tags
fi


# 4.
# remove .git dir before rsync
find $CHECKOUT_DIR -name .git -exec rm -rf '{}' \;


# 5.
# rsync --delete
/usr/bin/rsync -a -z -C --delete --verbose $CHECKOUT_DIR/ $REMOTE_HOST:$REMOTE_DIRECTORY

# 6.
# run bootstrap (this is for virtualenv in our Django projects)
ssh $REMOTE_HOST "cd ${REMOTE_DIRECTORY}; ./bootstrap.py"

# 7.
# touch the wsgi file to make apache restart the daemon
ssh $REMOTE_HOST touch ${REMOTE_DIRECTORY}/apache/django.wsgi 

# 8.
# apache configtest
# we don't restart apache automatically deployment, but we make sure 
# the current apache config is working or we get the error.
ssh $REMOTE_HOST /usr/sbin/apache2ctl configtest

