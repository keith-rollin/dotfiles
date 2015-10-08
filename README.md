### Installation:

```
$ cd
$ git clone git://github.com/keith-rollin/dotfiles.git
-- or --
$ git clone git@github.com:keith-rollin/dotfiles.git
```

### Create symlink(s):

```
$ ~/dotfiles/install_links.sh
```

### To add a new submodule:

```
$ git submodule add <github-path> ~/dotfiles/vim/bundle/<local-name>
$ <Commit changes>
```

### To update the submodules:

```
$ git submodule foreach git pull origin master
$ <Commit changes>
```

### To remove a submodule:

```
$ git submodule deinit <submodule>      # Updates .git/config and deletes working directory
$ git rm bundle/<submodule>             # Removes submodule from parent project
$ rm -rf .git/modules/<submodule>       # Remove sub-.git directory from parent .git directory
$ <Edit .gitmodules>                    # Remove submodule references in here
$ <Commit changes>
```
