### Installation:

```
$ git clone --recursive git://github.com/keith-rollin/dotfiles.git
```

or:

```
$ git clone --recursive git@github.com:keith-rollin/dotfiles.git
```

If you already cloned the repository without `--recursive`, use the following
to get the submodules checked-out:

```
$ git submodule update --init --recursive
```

### Create symlinks:

```
$ ~/dotfiles/install_links.sh
```

Then edit .gitconfig to have the right email address.

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
