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
|-- .clang-format -> $HPD/dotfiles/clang-format.in
|-- .config/
|   |-- nvim/
|   |   `-- init.vim -> $HPD/dotfiles/vim/init.vim
|   |-- op/
|   |   |-- config
|   |   `-- op-daemon.sock=
|   `-- zsh/
|       |-- zcompdump
|       `-- zsh_history
|-- .gitconfig -> $HPD/dotfiles/gitconfig
|-- .zshenv -> $HPD/dotfiles/zshenv
|-- .zshrc -> $HPD/dotfiles/zshrc
`-- src -> $HPD/src

$HPD/
`-- dotfiles/

/Volumes/Data (if it exists)
`-- .clang-format

/usr/local/ or /opt/homebrew/
`-- <homebrew directories>
```
