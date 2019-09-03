### Installation:

Before checking out:

* Add your GitHub SSH keys with `ssh-add`.
* Create a separate APFS volume at /Volumes/Data.
* Create a dev directory at /Volumes/Data/dev.

```bash
$ cd /Volumes/Data/dev
$ git clone git@github.com:keith-rollin/dotfiles.git
$ dotfiles/install
```

### Result:

```text
~
|-- .bash_profile@ -> /Volumes/Data/dev/dotfiles/bash_profile
|-- .bashrc@ -> /Volumes/Data/dev/dotfiles/bashrc
|-- .gitconfig@ -> /Volumes/Data/dev/dotfiles/gitconfig
|-- .inputrc@ -> /Volumes/Data/dev/dotfiles/inputrc
|-- .vim@ -> /Volumes/Data/dev/dotfiles/vim
|-- .zshrc@ -> /Volumes/Data/dev/dotfiles/zshrc
`-- dev@ -> /Volumes/Data/dev

/Volumes/Data/
`-- dev/
    |-- brew/
    |-- dotfiles/
    |-- dotfiles-work/  (only on my work systems)
    |-- tmp/
    |-- webkit/         (only on my work systems)
    `-- <various projects>
```
