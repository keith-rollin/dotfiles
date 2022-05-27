### Installation:

```bash
$ set HPD=<handy parent directory for "dotfiles">
$ cd $HPD
$ git clone https://github.com/keith-rollin/dotfiles.git
$ dotfiles/install
```

### Result:

* "dotfiles" upstream repo URL will be changed from "https" scheme to "git"
  scheme.

```text
$HOME/
|-- .bash_profile@ -> $HPD/dotfiles/bashrc
|-- .bashrc@ -> $HPD/dotfiles/bashrc
|-- .clang-format@ -> $HPD/dotfiles/clang-format.in
|-- .config/
|   |-- 1password/
|   |-- broot/
|   |-- emacs/
|   |-- nvim/init.vim@ -> $HPD/dotfiles/vim/init.vim
|   |-- op/
|   `-- starship.toml@ -> $HPD/dotfiles/starship.toml
|-- .gitconfig@ -> $HPD/dotfiles/gitconfig
|-- .inputrc@ -> $HPD/dotfiles/inputrc
|-- .vim@ -> $HPD/dotfiles/vim
|-- .zshrc@ -> $HPD/dotfiles/bashrc
|-- Library/Application Support/Sublime Text 3/Packages
|   `-- User -> $HPD/dotfiles/SublimeText-Packages-User/
`-- src@ -> $HPD/src

$HPD/
`-- dotfiles/

/Volumes/Data
`-- .clang-format

/usr/local/ or /opt/homebrew/
`-- <homebrew directories>
```
