### Installation:

Before checking out:

* Add your GitHub SSH keys with `ssh-add`.
* Create a separate APFS volume at /Volumes/Data.
* Create a dev directory at /Volumes/Data/totally-not-dev/dev. (Time Machine will not back up a directory named "dev" at the root of a volume.)

```bash
$ mkdir -p /Volumes/Data/totally-not-dev/dev
$ cd /Volumes/Data/totally-not-dev/dev
$ git clone git@github.com:keith-rollin/dotfiles.git
$ dotfiles/install
```

### Result:

```text
~
|-- .bash_profile@ -> /Volumes/Data/totally-not-dev/dev/dotfiles/bashrc
|-- .bashrc@ -> /Volumes/Data/totally-not-dev/dev/dotfiles/bashrc
|-- .gitconfig@ -> /Volumes/Data/totally-not-dev/dev/dotfiles/gitconfig
|-- .inputrc@ -> /Volumes/Data/totally-not-dev/dev/dotfiles/inputrc
|-- .vim@ -> /Volumes/Data/totally-not-dev/dev/dotfiles/vim
|-- .zshrc@ -> /Volumes/Data/totally-not-dev/dev/dotfiles/bashrc
`-- dev@ -> /Volumes/Data/totally-not-dev/dev

/Volumes/Data/totally-not-dev/
`-- dev/
    |-- brew/
    |-- dotfiles/
    |-- dotfiles-work/  (only on my work systems)
    |-- tmp/
    |-- webkit/         (only on my work systems)
    `-- <various projects>
```
