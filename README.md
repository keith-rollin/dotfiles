### Installation:

```
$ git clone --recursive git://github.com/keith-rollin/dotfiles.git
```

or:

```
$ git clone --recursive git@github.com:keith-rollin/dotfiles.git
```

If you already cloned the repository without `--recursive`, use the following to get the submodules checked-out:

```
$ git submodule update --init --recursive
```

Once the repository is checked out, you need to "hook up" the configuration files in to to the well-known top-level dot-files (.bashrc, etc.). Do that by running the following.

```
$ ~/dotfiles/install_links.sh
```

Then edit .gitconfig to have the right email address.

### Adding a submodule:

```
$ git submodule add <github-path> ~/dotfiles/vim/bundle/<local-name>
$ <Commit changes>
```

### Updating submodules:

To update the submodules to the latest versions in the upstream sources.

```
$ git submodule foreach git pull origin master
$ <Commit changes>
```

### Removing a submodule:

```
$ git submodule deinit <submodule>      # Updates .git/config and deletes working directory
$ git rm bundle/<submodule>             # Removes submodule from parent project
$ rm -rf .git/modules/<submodule>       # Remove sub-.git directory from parent .git directory
$ <Edit .gitmodules>                    # Remove submodule references in here
$ <Commit changes>
```
