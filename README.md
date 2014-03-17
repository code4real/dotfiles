# Dotfiles: reusable and customizable
Config and mini-scripts tuned for vim, zsh, i3, urxvt, repls, etc on various
operating system families/distros: bsd, linux, mac.

Most interesting areas:

* zsh (`.zshrc` top level control and file hierarchy)
* vim (`.vimrc` and `.vim/`)
* config (misc)
* bin scripts (add your own if not gists)

Notable features:

* Many handy settings, aliases, functions, completions, prompts, colors, etc

* Designates some standard dirs (via `.gitignore`s)

* Separates own dotfiles (`~/config`) from tool-installed (`~/.*` and
  `~/.config`) via symlinks; e.g., `~/.vimrc -> ~/config/vimrc`

* Provides `dotfiles` script (and several `d*` aliases) as a proxy for git

* Time-able and fast

## Installs
(Should really be a single, OS-flexible bootstrap script.)

### PC-BSD

Essential:
    pkg install coreutils zsh gawk i3 rxvt-unicode tmux vim

Niceties:
    pkg install chromium firefox lxappearance openjdk

## Arch Linux
    yaourt -S zsh i3 i3status rxvt-unicode tmux vim

## Fedora/CentOS
    yum install -y 

## Debian/Ubuntu

## Setup

1. Create a new user account if you don't already have one, or if want to try
   a fresh start. As a root/admin user, run:

        useradd -s /usr/bin/zsh -m YOUR_USERNAME

        # Or, for mac:
        ./useradd-mac.sh YOUR_USERNAME

1. Enable `sudo` on your account. Hopefully, it's already done; try this:
        sudo ls

1. Download the bootstrapping script:

1. Run the bootstrapping script to install some essential packages, clone the
   repo, and put the dotfiles into place.

        ./bootstrap.sh

1. Move your own config files temporarily into a scratch area for later
   reference.

        cd ~
        mkdir ~/tmp
        mv .bash* .zsh* tmp

1. Install Zsh and make sure it's your default shell

        chsh -s /usr/bin/zsh

1. Sign in to github and fork this repo to make your own which you can modify

1. Clone and set up for repo.

        git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/.dotfiles.git
        mv .dotfiles.git/.* .dotfiles.git/* .
        mv .git .dotfiles.git/

1. Try it out! (lots of `dotfiles` aliases, like `dst`, `dci`, etc)

        exec zsh
        alias dotfiles
        dotfiles «tab»

1. Visit all the `ENABLE` messages to delete them or follow their instruction.

1. Install the vim packages.

        git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
        vim +BundleInstall +qall

There are still vim (via [vundle](https://github.com/gmarik/Vundle.vim)) and
gist files to grab. I'll clean this up if someone requests.

You can also use the included `binstubs.zsh` to create a single `bin/` for
your gists.

## Layout

    *  README.md -- this file
    *  bin       -- small (usually standalone) scripts that I have written
    *  config    -- VCS-manageable, user-written CONFIGuration (mostly dot-files)
    *  contrib   -- other people's scripts that need to be under my control
    *  doc       -- text DOCuments I write, books, presentations, personal logs
    *  etc       -- system-specific symlinks to important sytem ETC files
    *  test      --
    +  proj      -- PROJects (or *any* code) I'm working on
    +  client    -- work done for development/consulting CLIENTs
    ^  archive   -- tarballs, extracts, checkouts
    ^  art       -- anything related to graphics; binary so not in VCS
    ^  exp       -- small-scale code/tests I'm working on only EXPerimentally
    ^  data      -- generated, machine-specific config DATA files
    ^  log       -- holds LOGs: installs, runs, reports
    ^  Documents -- binary DOCUMENTS, books, presentations
    ^  Books     -- EPUBs to be shared with other devices
    ^  Mail      -- all the mutt-managed MAIL
    ^  Music     -- songs, podcasts, etc
    ^  Photos    -- still shots (most mirrored to Flickr)
    ^  Videos    -- VIDEOS, screencasts (mirror to vimeo/viddler?)
    !  local     -- my LOCAL install tree (... --prefix=~/local)
    !  outgoing  -- temp queue for things (forSOMEONE.tgz) sent to others
    !  tmp       -- a manual trash can
    !  Downloads -- temp holding area
    &  .config   -- system tools dump settings here
    &  .local    -- system tools dump things here
    &  .*        -- 100s more dot-files/dirs not worth tracking or listing here

    Key:  * = $HOME-VCS-managed;         ^ = symlink-mirrored, not suited for VCS;
          + = individually VCS-managed;  ! = lose-able;
          & = used by system

## FAQs

**Which OSs can I use with code4real?**

Most Linux distro families are supported/tested: Arch, Debian (and Ubuntu, etc),
Red Hat (centos, fedora). FreeBSD and derivatives (PC-BSD) also works.

You can even use a Mac, though I encourage you to try out another more open
system. There are several easy and free ways (VirtualBox or USB-stick image)
to try out Linux or BSD.

**Which OS do you recommend?**

Prefer any OS that is as "open" as possible.

We presently use *Arch Linux* more than the others. It's very convenient to
have a rolling release, and the *yaourt* package manager makes for a very
strong means to share projects. Linux runs just about everywhere, so it's a
great choice if you're worried about hardware support.

*PC-BSD* is a really friendly OS to install, and pkgng makes installing packages
really easy. It's also an extension to the very robust FreeBSD, which is a
high performing server supporting ZFS and sophisticated system debugging via
DTrace.

**I prefer the FOO tool over the one you've selected.**

This setup can be customized to your liking. Feel free to use Emacs instead of
Vim, for example. But many of the tutorials that are part of code4real will be
featuring the supported tools that are included.
