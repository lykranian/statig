#!/bin/bash

 ########
# gitpls #
 ########

# a static page generator for git repos
# hosted at https://rectilinear.xyz/git/lyk/gitpls

VERSION="0.1.0"
ORIGINALWD=`echo $PWD`
NAME=$(basename $1 .git) # gets the repo name
GDIR="/tmp/gitpls" # repo storage dir

rm -rf $GDIR/pages/$NAME # removes previous pages dir if it exists
mkdir -p $GDIR/pages/$NAME # re-create a blank folder

mkdir -p $GDIR/repos/ # create base repo folder if non-existant
rm -rf $GDIR/repos/$NAME # remove previous repo dir

cd $GDIR/repos
git clone $1 --quiet # clone the repo
rm -rf $GDIR/repos/$NAME/.git # remove the .git folder

find $GDIR/repos/$NAME/ -type f -exec sh -c 'mv "$0" "${0%}.txt"' {} \; # add .txt suffix to all files

# page colors
LINKCOL="#444444"

# ↓ basic structure for writing to index
# printf "hello world" >> $GDIR/pages/$NAME/index.html
printf "<!DOCTYPE HTML>
<HTML>
  <HEAD>
    <TITLE>gitpls - $NAME</TITLE>
  <STYLE>
    body {
      background-color: #DDDDDD;
      font-color: #333333;
    }
    a:link {
      color: $LINKCOL;
    }
    a:visited {
      color: $LINKCOL;
    }
    a:hover {
      color: $LINKCOL;
    }
    a:active {
      color: $LINKCOL;
    }
  </STYLE>
  </HEAD>
  <BODY>
    <center>
      gitpls - $NAME<br/><br/>" >> $GDIR/pages/$NAME/index.html


find $GDIR/repos/$NAME/ -type f|while read fullname; do
				    # FNAME=$(basename $fullname .txt) # if your try_files equivalent has $uri.txt
				    FNAME=$(echo $fullname | sed "s:$GDIR\/repos\/$NAME\/::")
				    RNAME=$(echo $FNAME | sed "s:.txt$::")
				    printf "\n      <a href=\"files/$FNAME\">$RNAME</a>" >> $GDIR/pages/$NAME/index.html
				    printf "<br/>" >> $GDIR/pages/$NAME/index.html
				done
printf "\n  </BODY>
</HTML>" >> $GDIR/pages/$NAME/index.html
cp -R $GDIR/repos/$NAME $GDIR/pages/$NAME/files

cd $ORIGINALWD
