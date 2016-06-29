#!/bin/bash

 ########
# gitpls #
 ########

# a static page generator for git repos
# hosted at https://rectilinear.xyz/git/lyk/gitpls

VERSION="0.1.2"
ORIGINALWD=`echo $PWD`
NAME=$(basename $1 .git) # gets the repo name
GDIR="/tmp/gitpls" # repo storage dir

mkdir -p $GDIR/ # create base repo folder if non-existant
rm -rf $GDIR/$NAME # remove previous repo dir

BRANCH="master"
if [ $2 ]; then
  BRANCH=$2
fi

cd $GDIR
git clone $1 --quiet # clone the repo
cd $GDIR/$NAME
git checkout $BRANCH --quiet
cd $GDIR
rm -rf $GDIR/$NAME/.git # remove the .git folder

find $GDIR/$NAME/ -type f -exec sh -c 'mv "$0" "${0%}.txt"' {} \; # add .txt suffix to all files
mkdir $GDIR/$NAME/files
mv $GDIR/$NAME/* /$GDIR/$NAME/files/ 2>/dev/null
# page colors
LINKCOL="#444444"

# ↓ basic structure for writing to index
# printf "hello world" >> $GDIR/$NAME/index.html
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
      gitpls - $NAME<br/><br/>" >> $GDIR/$NAME/index.html


find $GDIR/$NAME/files -type f|while read fullname; do # populates html file with links
				   # FNAME=$(basename $fullname .txt) # if your try_files equivalent has $uri.txt
				   FNAME=$(echo $fullname | sed "s:$GDIR\/$NAME\/::")
				   RNAMEPRE=$(echo $FNAME | sed "s:.txt$::")
				   RNAME=$(echo $RNAMEPRE | sed "s:files\/::")
				   printf "\n      <a href=\"$FNAME\">$RNAME</a>" >> $GDIR/$NAME/index.html
				   printf "<br/>" >> $GDIR/$NAME/index.html
			       done
printf "\n  </BODY>
</HTML>" >> $GDIR/$NAME/index.html # end html output

cd $ORIGINALWD # not needed?
