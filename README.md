### Installation:

Before checking out, be sure to add your GitHub SSH keys with `ssh-add`.

```bash
$ mkdir dev && cd dev # In ~/Documents at home, in /Volumes/Data at work.
$ git clone git@github.com:keith-rollin/dotfiles.git
$ dotfiles/install
```

### Result:

#### Work:

```text
~
|-- dev -> /Volumes/Data/dev
`-- Documents/
    `-- dev/
        `-- Projects shared via iCloud

/Volumes/Data/
`-- dev/
    |-- brew/
    |-- dotfiles/
    `-- Projects shared via shared partition
```

#### Home:

```text
~
|-- brew/
|-- dev -> ~/Documents/dev
`-- Documents/
    `-- dev/
        |-- brew -> ~/brew
        |-- dotfiles
        `-- Projects shared via iCloud
```
