# statig
a static page generator for hosting git repos.

see <a href="https://rectilinear.xyz/repos/vibrant/">some</a> <a href="https://rectilinear.xyz/repos/statig/">samples</a>.

#### usage
`./statig.sh repo branch` where `repo` is a path or a link to a git repo. `branch` is optional, it defaults to master.

creates `/tmp/statig/REPONAME/` which can be copied to your webserver directory, or you can change the `$target` to your web directory. it contains a file `index.html` and a directory `files`. the file `index.html` contains the repo's readme.

#### deps
requires `git pandoc`

#### todo:  
 - syntax hilighting
 - proper page design
 - improve css 
 - fallbacks if deps aren't present