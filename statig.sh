#!/usr/bin/env bash

 ########
# statig #
 ########

# a static page generator for git repos
# hosted at https://rectilinear.xyz/git/lyk/statig

version="0.1.3"

# options:
target="/tmp/statig" # script delivers to $target/$name/
webtarget="/tmp/statig" # where on webhost generated dir will go
                         # https://example.com/repos/"reponame"
theme="dark" # dark or light, more to be added
#end options

ORIGINALWD=`echo $PWD`
name=$(basename $1 .git) # gets the repo name

mkdir -p $target/ # create base repo folder if non-existant
rm -rf $target/$name # remove previous repo dir

branch="master"
if [ $2 ]; then
    branch=$2
fi

cd $target
git clone $1 --quiet # clone the repo
cd $target/$name
git checkout $branch --quiet # checks out desired branch
git clean -xdf # applies .gitignore as double safety (not required after a clean pull)
rm -rf $target/$name/.git # remove the .git folder
cd $target/

# generates html readme
readmefile=$(ls $target/$name/ | while read readmefiles ;do grep -i readme ;done)
readme=$(pandoc -f markdown $target/$name/$readmefile)

find $target/$name/ -type f -exec sh -c 'mv "$0" "${0%}.txt"' {} \; # add .txt suffix to all files
mkdir $target/$name/files
mv $target/$name/* /$target/$name/files/ 2>/dev/null
mv $target/$name/.* /$target/$name/files/ 2>/dev/null

# css variables
if [ $theme == "light" ]; then
    linkcol="#444"
    bgcol="#DDD"
    fgcol="#333"
elif [ $theme == "dark" ]; then
    linkcol="#aaa"
    bgcol="#2d2d2d"
    bgcol2="#3d3d3d"
    fgcol="#ddd"
    bordercol="#1d1d1d"
else # fallback is light theme
    linkcol="#444"
    bgcol="#DDD"
    fgcol="#333"
fi
# create and fill $target/$name/css/style.css
# use \" for "
css="<style>

      body {
        margin: 0;
        padding: 0;
        background-color:$bgcol;
        color:$fgcol;
        font-family: \"Droid Sans\", \"Lucida Sans Unicode\", \"Lucida Grande\", sans-serif;
        text-align:center;
        font-size: 1em;
      }
      ::-webkit-scrollbar {
        width: 10px;
        height: 10px;
      }
      ::-webkit-scrollbar-thumb {
        background-color: $linkcol;
      }
      @media only screen and (-webkit-min-device-pixel-ratio: 1.5),
      only screen and (-o-min-device-pixel-ratio: 15/10),
      only screen and (min-resolution: 150dpi)
      {
        body {
          font-size: 36px;
        }
      }
      a:link { color: $linkcol; }
      a:visited { color: $linkcol; }
      a:hover { color: $linkcol; }
      a:active { color: $linkcol; }

      pre {
        background-color:$bgcol;
        margin-left: -5px;
        margin-right: -5px;
        padding: 5px;
      }

      .filebox {
        background-color: $bgcol2;
        border:2px solid $bordercol;
        text-align: left;
        display: inline-block;
        max-width: 90vw;
        margin-left: auto ;
        margin-right: auto ;
        padding: 5px;
      }
    </style>"

# html head contents
# use \" for "
head="<meta name=\"robots\" content=\"noindex, nofollow\" />
    <meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\" />"

# ↓ basic structure for writing to index
# printf "hello world" >> $target/$name/index.html
# use \" for "
printf "<!DOCTYPE HTML>
<html>
  <head>
    <title>statig - $name</title>
    $head
    $css
  </head>
  <body>
    <h1>$name</h1>
    <div class=\"filebox\">" >> $target/$name/index.html

find $target/$name/files|while read fullname; do # populates html file with links
                             if [[ -d $fullname ]]; then
                                 dirname=$(echo $fullname | sed "s:$target\/$name\/::")
                                 cleandirname=$(echo $dirname | sed "s:files\/::")
                                 indexname=$(basename $dirname)
                                 parentdirname=$(dirname $cleandirname)
                                 if [[ $fullname == $target/$name/files ]]; then
                                     continue # stops the creation of .../files/index.txt, in case one already exists in the repo
                                 fi           # i don't think it's needed anymore?

                                 printf "<!DOCTYPE HTML>
<html>
  <head>
    <title>statig - $name</title>
    $head
    $css
  </head>
  <body>
    <h1>$name/$cleandirname</h1>
    <div class=\"filebox\">" >> $target/$name/$dirname/index.html

                                 if [[ $parentdirname == "." ]]; then # ↓ remove this /index.html if try_files has index.html
                                     printf "\n      <a href=\"$dirname/index.html\">$cleandirname/</a>" >> $target/$name/index.html
                                     printf "<br/>" >> $target/$name/index.html # prints subdirs to main index file
                                 else
                                     printf "\n      <a href=\"$indexname/index.html\">$indexname/</a>" >> $target/$name/files/$parentdirname/index.html
                                     printf "<br/>" >> $target/$name/files/$parentdirname/index.html # prints (n)subdir to (n-1)subdir index files
                                 fi
                             else [[ -f $fullname ]];

                                  # fullname=$(basename $fullname .txt) # uncomment if your try_files equivalent has $uri.txt
                                  filename=$(echo $fullname | sed "s:$target\/$name\/::")
                                  linknamepre=$(echo $filename | sed "s:.txt$::")
                                  linkname=$(echo $linknamepre | sed "s:files\/::")
                                  cleanlinkname=$(basename $linkname)
                                  parentdirname=$(dirname $linkname)

                                  if [[ $parentdirname == "." ]]; then
                                      printf "\n      <a href=\"$filename\">$cleanlinkname</a>" >> $target/$name/index.html
                                      printf "<br/>" >> $target/$name/index.html # prints root dir file links
                                  else
                                      printf "\n      <a href=\"$cleanlinkname.txt\">$cleanlinkname</a>" >> $target/$name/files/$parentdirname/index.html
                                      printf "<br/>" >> $target/$name/files/$parentdirname/index.html # prints subdir file links
                                  fi
                             fi
                         done

find $target/$name/files -type f -name "index.html"|while read indexname; do # end html files
                                                        printf "\n    </div>
  </body>
</html>" >> $indexname
                                                    done
printf "\n    </div>
  <br/><br/>
  <div class=\"filebox\">
    $readme
  </div>
  <br/><br/>
  </body>
</html>" >> $target/$name/index.html

cd $ORIGINALWD # not needed?
