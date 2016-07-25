#!/bin/bash

 ########
# gitpls #
 ########

# a static page generator for git repos
# hosted at https://rectilinear.xyz/git/lyk/gitpls

VERSION="0.1.2"
ORIGINALWD=`echo $PWD`
NAME=$(basename $1 .git) # gets the repo name
GITDIR="/tmp/gitpls" # repo storage dir

mkdir -p $GITDIR/ # create base repo folder if non-existant
rm -rf $GITDIR/$NAME # remove previous repo dir

BRANCH="master"
if [ $2 ]; then
  BRANCH=$2
fi

cd $GITDIR
git clone $1 --quiet # clone the repo
cd $GITDIR/$NAME
git checkout $BRANCH --quiet # checks out desired branch
git clean -xdf # applies .gitignore as double safety (not required after a clean pull)
rm -rf $GITDIR/$NAME/.git # remove the .git folder
cd $GITDIR/

find $GITDIR/$NAME/ -type f -exec sh -c 'mv "$0" "${0%}.txt"' {} \; # add .txt suffix to all files
mkdir $GITDIR/$NAME/files
mv $GITDIR/$NAME/* /$GITDIR/$NAME/files/ 2>/dev/null
mv $GITDIR/$NAME/.* /$GITDIR/$NAME/files/ 2>/dev/null
# page colors
LINKCOL="#444444"
BGCOL="DDDDDD"
FGCOL="333333"

# ↓ basic structure for writing to index
# printf "hello world" >> $GITDIR/$NAME/index.html
printf "<!DOCTYPE HTML>
<html>
  <head>
    <title>gitpls - $NAME</title>
  <style>
    body { background-color:#BGCOL; font-color:#FGCOL; text-align:center;}
    a:link { color: $LINKCOL; }
    a:visited { color: $LINKCOL; }
    a:hover { color: $LINKCOL; }
    a:active { color: $LINKCOL; }
  </style>
  </head>
  <body>
    gitpls - $NAME<br/><br/>" >> $GITDIR/$NAME/index.html

find $GITDIR/$NAME/files|while read fullname; do # populates html file with links
                           if [[ -d $fullname ]]; then
                               DIRNAME=$(echo $fullname | sed "s:$GITDIR\/$NAME\/::")
			       CLEANDIRNAME=$(echo $DIRNAME | sed "s:files\/::")
			       INDEXNAME=$(basename $DIRNAME)
			       PARENTDIRNAME=$(dirname $CLEANDIRNAME)
			       if [[ $fullname == $GITDIR/$NAME/files ]]; then
				  continue # stops the creation of .../files/index.txt, in case one already exists in the repo
			       fi

			       printf "<!DOCTYPE HTML>
                                       <html>
                                       <head>
                                       <title>gitpls - $NAME</title>
                                       <style>
                                         body { background-color:#BGCOL; font-color:#FGCOL; text-align:center;}
                                         a:link { color: $LINKCOL; }
                                         a:visited { color: $LINKCOL; }
                                         a:hover { color: $LINKCOL; }
                                         a:active { color: $LINKCOL; }
                                       </style>
                                       </head>
                                       <body>
                                         gitpls - $NAME/$CLEANDIRNAME<br/><br/>" >> $GITDIR/$NAME/$DIRNAME/index.html

                                                                # ↓ remove this /index.html if your try_files has index.html
                               if [[ $PARENTDIRNAME == "." ]]; then
                                   printf "\n    <a href=\"$DIRNAME/index.html\">$CLEANDIRNAME/</a>" >> $GITDIR/$NAME/index.html
                                   printf "<br/>" >> $GITDIR/$NAME/index.html
                               else
                                   printf "\n    <a href=\"$INDEXNAME/index.html\">$INDEXNAME/</a>" >> $GITDIR/$NAME/files/$PARENTDIRNAME/index.html
                                   printf "<br/>" >> $GITDIR/$NAME/files/$PARENTDIRNAME/index.html
                               fi
                           else [[ -f $fullname ]];

                                   # fullname=$(basename $fullname .txt) # uncomment if your try_files equivalent has $uri.txt
                                   FILENAME=$(echo $fullname | sed "s:$GITDIR\/$NAME\/::")
                                   LINKNAMEPRE=$(echo $FILENAME | sed "s:.txt$::")
                                   LINKNAME=$(echo $LINKNAMEPRE | sed "s:files\/::")
				   CLEANLINKNAME=$(basename $LINKNAME)
				   PARENTDIRNAME=$(dirname $LINKNAME)
				   
			       if [[ $PARENTDIRNAME == "." ]]; then
                                   printf "\n    <a href=\"$FILENAME\">$CLEANLINKNAME</a>" >> $GITDIR/$NAME/index.html
                                   printf "<br/>" >> $GITDIR/$NAME/index.html
                               else
                                   printf "\n    <a href=\"$CLEANLINKNAME.txt\">$CLEANLINKNAME</a>" >> $GITDIR/$NAME/files/$PARENTDIRNAME/index.html
                                   printf "<br/>" >> $GITDIR/$NAME/files/$PARENTDIRNAME/index.html
                               fi
                           fi
                                 done
printf "\n  </BODY>
</HTML>" >> $GITDIR/$NAME/index.html # end html output

cd $ORIGINALWD # not needed?
