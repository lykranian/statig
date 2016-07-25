# gitpls

a static page generator for hosting git repos

##### this is a proof of concept written in bash
<a href="https://rectilinear.xyz/gitpls/sshuttle/">sample output</a>

#### usage
`./gitpls.sh repo branch` where repo is a path or a link to a git repo, and branch is the branch name, defaulting to master

creates `/tmp/gitpls/REPONAME/` which can be copied to your webserver directory, or you can change the $GDIR to your web directory. it contains a file `index.html` and a directory `files`.

#### the aim is to provide:  
 - a single bash script for generating a directory of static html files for each file in a git repo
 - markdown support
 - easy-to-modify css theming

###### stay tuned