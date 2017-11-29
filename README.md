### Preparation:

Three things to know about before checking out and using the `install` script:

1. Before trying to check out on a new system, use `ssh-add` to add my GitHub
   private key to the SSH agent.
1. Before running install, maybe get and use my git-crypt key. If I do this,
   then specify it on the command line with --key.
1. Also, in some configurations, I may want to handle the "brew" directory
   differently. At work, I share some projects via iCloud Drive, and some
   (including "brew") via a shared partition. At home, I have pretty much all
   my projects in iCloud Drive, but I still want "brew" outside of this so that
   it doesn't get copied up to iCloud Drive. To support this, I put "brew" in
   my home directory and a link to it in my "dev" directory.

```
Work:

~
|-- dev -> /Volumes/Data/dev
`-- Documents/
    `-- dev/
        `-- Projects shared via iCloud

/Volumes/Data/dev
|-- Projects shared via shared partition
|-- brew/
`-- dotfiles/
```

```
Home:

~
|-- brew/
|-- dev -> ~/Documents/dev
`-- Documents/
    |-- brew -> ~/brew
    `-- dev/
        |-- Projects shared via iCloud
        `-- dotfiles
```


### Installation:

```bash
$ git clone --recursive git@github.com:keith-rollin/dotfiles.git
```

Once the repository is checked out, you need to link the various configuration
files to the well-known top-level dot-files (.bashrc, etc.). Install the links
by running the `install` script, which will create them in a safe manner
(making sure it doesn't overwrite any plain files).

```bash
$ ~/dotfiles/install
```
