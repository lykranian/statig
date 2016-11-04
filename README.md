# statig

a static page generator for hosting git repos

currently has simple markdown support for a README.md

#### usage
`./statig.sh repo branch` where `repo` is a path or a link to a git repo. `branch` is optional, it defaults to master.

creates `/tmp/statig/REPONAME/` which can be copied to your webserver directory, or you can change the $target to your web directory. it contains a file `index.html` and a directory `files`.

#### deps
requires `git pandoc`

#### todo:  
 - syntax hilighting
 - proper page design
 - improve css 
 - fallbacks if deps aren't present