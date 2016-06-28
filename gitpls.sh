#!/bin/bash

 ########
# gitpls #
 ########

# a static page generator for git repos
# hosted at https://rectilinear.xyz/git/lyk/gitpls

VERSION="0.0.1"
ORIGINALWD=`echo $PWD`
NAME=$(basename $1 .git) # gets the repo name
GDIR="/tmp/gitpls" # repo storage dir

rm -rf $GDIR/pages/$NAME
mkdir -p $GDIR/pages/$NAME

mkdir -p $GDIR/repos/
rm -rf $GDIR/repos/$NAME

cd $GDIR/repos
git clone $1 --quiet 
printf "cloned into $GDIR/repos/$NAME\n"
rm -rf $GDIR/repos/$NAME/.git

find $GDIR/repos/$NAME/ -type f -exec sh -c 'mv "$0" "${0%}.txt"' {} \;
#find $GDIR/repos/$NAME/ -type f -exec sh -c "printf `basename` >> ${GDIR%}/pages/${NAME%}/index.txt" {} \;
find $GDIR/repos/$NAME/ -type f|while read fullname; do
				    # FNAME=$(basename $fullname .txt) # if your try_files equivalent has $uri.txt
				    FNAME=$(echo $fullname | sed "s:$GDIR\/repos\/$NAME\/::")
				    RNAME=$(echo $FNAME | sed "s:.txt$::")
				    printf "<a href=\"files/$FNAME\">$RNAME</a>\n" >> $GDIR/pages/$NAME/index.html
				    printf "<br/>" >> $GDIR/pages/$NAME/index.html
				done

cp -R $GDIR/repos/$NAME $GDIR/pages/$NAME/files

cd $ORIGINALWD
