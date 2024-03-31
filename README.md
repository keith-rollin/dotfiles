### Installation:

```bash
$ HPD=<handy parent directory for "dotfiles">
$ cd $HPD
$ git clone https://github.com/keith-rollin/dotfiles.git
$ dotfiles/install
```

### Result:

* "dotfiles" upstream repo URL will be changed from "https" scheme to "git"
  scheme.

```text
$HPD/
`-- dotfiles/

$HOME/
|-- .clang-format -> $HPD/dotfiles/clang-format.in
|-- .config/
|   |-- 1password/
|   |   `-- ssh/
|   |       `-- agent.toml -> $HPD/dotfiles/config/agent.toml
|   |-- nvim -> $HPD/vim/
|   `-- twine/
|       `-- pypirc -> $HPD/config/pypirc
|-- .local/
|       state/
|       |-- nvim/
|       |   `-- ... plugin stuff ...
|       |-- python/
|       |   `-- python_history
|       |-- rust/
|       |   |-- cargo/
|       |   `-- rustup/
|       `-- zsh/
|           |-- zcompdump
|           `-- zsh_history
|-- .gitconfig -> $HPD/dotfiles/gitconfig
|-- .zshenv -> $HPD/dotfiles/zshenv
|-- .zshrc -> $HPD/dotfiles/zshrc
`-- src -> $HPD/src

/usr/local/ or /opt/homebrew/
`-- <homebrew directories>
```
