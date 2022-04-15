### Installation:

Before checking out:

* Add your GitHub SSH keys with `ssh-add`.
* Create a separate APFS volume at /Volumes/Data.
* Create a src directory at /Volumes/Data/src.

```bash
$ mkdir -p /Volumes/Data/src
$ cd /Volumes/Data/src
$ git clone git@github.com:keith-rollin/dotfiles.git
$ dotfiles/install
```

### Result:

```text
$HOME/
|-- .bash_profile@ -> /Volumes/Data/src/dotfiles/bashrc
|-- .bashrc@ -> /Volumes/Data/src/dotfiles/bashrc
|-- .clang-format@ -> /Volumes/Data/src/dotfiles/clang-format.in
|-- .config/nvim/init.vim@ -> /Volumes/Data/src/dotfiles/vim/init.vim
|-- .config/starship.toml@ -> /Volumes/Data/src/dotfiles/starship.toml
|-- .gitconfig@ -> /Volumes/Data/src/dotfiles/gitconfig
|-- .inputrc@ -> /Volumes/Data/src/dotfiles/inputrc
|-- .vim@ -> /Volumes/Data/src/dotfiles/vim
|-- .zshrc@ -> /Volumes/Data/src/dotfiles/bashrc
`-- src@ -> /Volumes/Data/src

/Volumes/Data/src/
|-- brew/ -> /usr/local
|-- dotfiles/
|-- tmp/
`-- <various projects>

/usr/local
`-- <homebrew files>
```
