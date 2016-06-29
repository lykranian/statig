# gitpls

a static page generator for hosting git repos

##### this is a proof of concept written in bash

#### usage
`./gitpls.sh repo` where repo is a path or a link to a git repo

creates `/tmp/gitpls/REPONAME/` which can be copied to your webserver directory, or you can change the $GDIR to your web directory. it contains a file `index.html` and a directory `files`.

#### the aim is to provide:  
 - a single bash script for generating a directory of static html files for each file in a git repo
 - markdown support
 - syntax hilighting
 - easy-to-modify css theming

###### stay tuned