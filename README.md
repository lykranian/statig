# statig

a static page generator for hosting git repos

#### usage
`./statig.sh repo branch` where `repo` is a path or a link to a git repo. `branch` is optional, it defaults to master.

creates `/tmp/statig/REPONAME/` which can be copied to your webserver directory, or you can change the $target to your web directory. it contains a file `index.html` and a directory `files`.

#### the aim is to provide:  
 - a single bash script for generating a directory of static html files for each file in a git repo
 - markdown support
 - easy-to-modify css theming

###### stay tuned