#!/bin/bash

 ########
# gitpls #
 ########

# a static page generator for git repos
# hosted at https://rectilinear.xyz/git/lyk/gitpls

VERSION="0.0.1"
ORIGINALWD=`echo $PWD`
NAME=$(basename $1 .git) # gets the repo name
RDIR="/tmp/gitpls/repos" # repo storage dir

mkdir -p $RDIR
cd $RDIR
rm -rf $NAME
git clone $1 --quiet 
echo cloned into $RDIR/$NAME
rm -rf $RDIR/$NAME/.git

find $RDIR/$NAME/ -type f -exec sh -c 'mv "$0" "${0%}.txt"' {} \;

cd $ORIGINALWD
