# Code4Real Dotfiles Distribution: reusable and customizable

Configuration and mini-scripts tuned for zsh, vim, urxvt, tmux, repls, etc on
various operating system families/distros: bsd, linux, mac. 256-color support
is featured throughout the stack. Additional setup of X11, fonts, and I3-WM is
included but optional. Tested on various servers, laptops (including
Chromebooks), and minimalistic devices like the RaspberryPi.

**Suited for neophytes and professionals alike.**

Watch the [bootstrapping tutorial screencast](http://code4real.com/bootstrapping)
(not yet published) to work through the steps herein.

Just about any UNIX-like operating system is supported (not
MS-Windows/Cygwin).

(TODO: add GIF showing some examples of tools in action)

Notable features:

* Bootstrapping/install script for easy and quick starting on most operating
  systems

* Well documented code -- easy to understand and fork-n-hack!

* Full Zsh and LiveScript/NodeJS programming environment for systems and web
  development

* Many handy settings, aliases, functions, completions, prompts, colors, etc,
  evolved over 15 years of diverse, professional software development
  experience

* A cohesive set of mnemonic vim-like keyboard shortcuts/mappings similar
  across all tools

* Well structured and modular: separates own dotfiles (`~/config`) from
  tool-installed (`~/.*` and `~/.config`) via symlinks; e.g., `~/.vimrc ->
  ~/config/vimrc`.
  
* Modular (vs monolithic) confiig enables safe reloading of single modules
  (`re-funcs`, `re-aliases`, etc)

* Designates standard directory structure (e.g., `src`, `local`, `bin`,
  `config`, via `.gitignore`s)

* Provides `dotfiles` git-wrapper script (and several `d*` aliases) as a
  convenient proxy for git, to manage full portable environment

* Time-able, tunable, friendly, and fast

* Tested on ArchLinux, Ubuntu, Debian, Fedora, Centos, and PC-BSD/FreeBSD

* Integrates with the parallel Code4Real student curriculum and tutorials
  (coming soon). But great for non-student professionals, too.

* Optional X11/I3 setup with shortcuts for multi-monitor and mouse toggling.
  Various keyboard enhancements: mappings to assign CapsLock, Esc, Alt,
  tilde/backtick, etc to ergonomically safe positions, faster keyboard repeat
  rates

Most interesting top-level areas:

* `config/` --  top level control and hierarchy for vim, zsh, tmux, x11, etc
* `contrib/` -- several small helper scripts not commonly available
* `bin/` -- your scripts (add your own if not gists)
* `.*` -- various other config symlinks to files and directories


## Installing prerequisites

A `bootstrap.sh` script can be downloaded
[here](https://raw.github.com/code4real/dotfiles/master/bootstrap.sh). Running
it will install the required missing utilities onto your system. You'll need
root privileges to install them. If you're a student on a shared system, your
instructor may have already done the installation, but everyone should
"bootstrap" to prepare their personal environment.


## Setup

Follow these instructions to have a fully functioning programming environment.
A `%` prompt is not to be copied/pasted, but indicates that you're logged in
as yourself. Likewise, a `#` prompt means the root user is active.

1. **Create a new user account** if you don't already have one or just want to
   try a fresh start. As a root/admin user, run:

        # useradd -s /usr/bin/zsh -m YOUR_USERNAME

   Or, for mac, download the
   [useradd script](https://raw.github.com/code4real/dotfiles/master/contrib/bin/useradd-mac.sh),
   and run:
        # ./useradd-mac.sh YOUR_USERNAME

   **OR**, if you're building off your **existing account**, make Zsh your default
   shell:

        % chsh -s /usr/bin/zsh

   Then **log out** fully from X or reboot.

1. Log in and you'll now be starting Zsh! You'll see a menu prompt to set up
   an environment. You don't want that, so press `0`.

1. *(optional for students)* **Enable `sudo`** on your account. Hopefully, it's
   already done; try this:
        % sudo ls

   If that fails, you can have the root user add your account to the `wheel`
   group.

        # usermod -aG wheel YOUR_USERNAME

1. Download the bootstrapping script:

        wget https://raw.github.com/code4real/dotfiles/master/bootstrap.sh
        (or just download it with your web browser if you don't yet have wget)

1. Run the bootstrapping script to install some essential packages, clone the
   repo, and put the dotfiles into place.

        bash ./bootstrap.sh

1. Move your own existing config files temporarily into a scratch area for
   later reference/merging.

        cd ~
        mkdir ~/tmp
        mv .bash* .zsh* .vim* ~/tmp/

1. Sign in to [github](http://github.com) and fork this repo to make your own
   which you can modify

1. Clone and set up your new repo.

        git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/.dotfiles.git
        mv .dotfiles.git/.* .dotfiles.git/* .
        mv .git .dotfiles.git/

1. Try it out! (lots of `dotfiles` aliases, like `dst`, `dci`, etc)

        exec zsh
        alias dotfiles
        dotfiles «tab»

1. Visit all the `ENABLE` messages to delete them or follow their instruction.


## About the toolbox

The following are the integral parts of the Code4Real stack. You'll be using
them all at once! All of these are covered in depth at Code4Real, but links to
extended resources are also mentioned.

(TODO: add logos for each)

* [ArchLinux](https://www.archlinux.org/) or [PC-BSD](http://www.pcbsd.org/)
  (or some other UNIX-like operating system) -- fully open source
  distributions and run on a multitude of hardware types. They have vibrant
  communities, and their package managers make it easy to install anything and
  contribute back to open source. PC-BSD is a breeze to install, but
  installing Arch is a wonderful learning experience that will benefit all
  neophytes. These OSs are the backbone of the internet, and also make for
  optimal development environments. Gaining intimate familiarity with either
  of these will propel you through a lucrative career of programming and
  sytems administration.

* [Zsh](http://www.zsh.org/) -- an extended Bourne shell with a large number
  of improvements, including some features of bash, ksh, and tcsh. Powerful
  even as a scripting language, and contains the most robust completion and
  built-in documentation systems of any shell. A great environment and
  language in which to start programming.

* [Vim](http://www.vim.org/) -- an IMproved version of Vi, a highly
  configurable text editor built to enable efficient text editing. Vi has been
  broadly available on nearly every UNIX system for 30+ years.

* [Git](http://git-scm.com/) -- a free and open source distributed
  version control system designed to handle everything from small to very
  large projects with speed and efficiency. All your projects will be managed
  and shared by git.

* [Dotfiles Home Environment]() -- git wrapper system and set of aliases to
  manage your environment. Take your environment with you everywhere, and be
  up-and-running on any new machine within minutes.

* [URxvt](https://wiki.archlinux.org/index.php/rxvt-unicode) -- a highly
  customizable terminal emulator. URxvt consumes minimal system
  resources, supports international language through Unicode, displays text
  and symbols in 256 colors (vs the typical 16) and has the ability to display
  multiple font types and effects, including bold, italic, underline, and
  inverse. Copy/paste work well across to other windows. Plays nicely with...

* [tmux](http://tmux.sourceforge.net/) -- lets you switch easily between
  several programs in one terminal, remote or local, detach them (they keep
  running in the background) and reattach them to a different terminal. Great
  for tiling multiple windows and sharing sessions across machines or with
  others.

* [LiveScript](http://livescript.net/) -- an extensive programming language
  which compiles to JavaScript, the web's ubiquitous language/platform. It has
  a straightforward mapping to JavaScript and allows you to write expressive
  code devoid of repetitive boilerplate. While LiveScript adds many features
  to assist in functional style programming, it also has many improvements for
  object oriented and imperative programming. Our go-to language when we need
  to go beyond Zsh (for expressiveness or going outside the console).
  LiveScript is well suited for web apps running in browsers and for systems
  programming via...

* [NodeJS](http://nodejs.org/) -- a platform built on Chrome's JavaScript
  runtime for easily building fast, scalable network applications. Node.js
  uses an event-driven, non-blocking I/O model that makes it lightweight and
  efficient.

* [NVM](https://github.com/creationix/nvm) -- simple script to manage and
  enable multiple active NodeJS versions. At some point you'll want to use
  different versions of Node for different purposes. NVM also makes it easy to
  install/upgrade new (and old) versions of Node to your local non-system
  areas.

* [GNU CoreUtils](http://www.gnu.org/software/coreutils/) -- the basic file,
  shell and text manipulation utilities of the GNU operating system, such as
  rm, pwd, cat, wc, date, touch, etc. The CoreUtils package is not installed
  on BSD systems by default, due to their licensing. BSD has alternate
  versions of these commands, but their options and behaviors are different in
  enough enough ways to cause headaches. These little tools are the backbone
  of the UNIX toolchain, so we'll install and rely on the single consistent
  CoreUtils set even when on BSD.

* [Yaourt]()/[AUR]() and [pkgng](https://wiki.freebsd.org/pkgng) -- package
  managers and repositories that make it easy to install everything under the
  sun, and even create and share our own packages.
  (FIXME: remove this bullet, or might as well get into systemd and rc.d)

* *(optional)* [I3](http://i3wm.org/) (on
  [X11](http://en.wikipedia.org/wiki/X_Window_System)) -- a light-weight and
  minimalist tiling window manager (WM) that is simple to install/configure,
  and features Vim-like operation, plus tabbed and floating windows, and
  sensible multi-monitor support. A custom color theme and vim bindings are
  included. Great
  [key-bindings reference here](http://i3wm.org/docs/userguide.html#_default_keybindings).

* *(optional)* [OrpFont](https://github.com/MicahElliott/Orp-Font) -- small
  bitmap pixel-perfect fonts in medium, bold, italic, book, with extended
  glyphs, for X11. If you like to fill your consoles with a lot of code at a
  time, these are for you. Tuned for Unicode/URxvt.


## Detailed layout

    *  README.md -- this file
    *  bin       -- small (usually standalone) scripts that I have written
    *  config    -- git-manageable, user-written CONFIGuration (mostly dot-files)
    *  contrib   -- others' scripts that need to be under my control
    *  doc       -- text DOCuments I write, books, presentations, personal logs
    *  etc       -- system-specific symlinks to important sytem ETC files
    *  test      -- programmatically test this dotfiles environment
    +  proj      -- PROJects (or *any* code) being worked on
    +  client    -- work done for development/consulting CLIENTs
    ^  src       -- tarballs, extracts, checkouts of others' source code
    ^  art       -- anything related to graphics; binary so not in git
    ^  exp       -- small-scale code/tests I'm working on only EXPerimentally
    ^  data      -- generated, machine-specific config DATA files
    ^  log       -- holds LOGs: installs, runs, reports
    ^  Documents -- binary documents, presentations
    ^  Books     -- EPUBs to be shared with other devices
    ^  Mail      -- all the mutt-managed MAIL
    ^  Music     -- songs, podcasts, etc
    ^  Photos    -- still shots
    ^  Videos    -- videos, screencasts
    !  local     -- LOCAL install tree (... --prefix=~/local)
    !  outgoing  -- temp queue for things (forSOMEONE.tgz) sent to others
    !  tmp       -- a manually emptied trash can (set as TMPDIR)
    !  Downloads -- temp holding area
    &  .config   -- system tools dump settings here
    &  .local    -- system tools dump things here
    &  .*        -- 100s more dot-files/dirs created by utils

    Key:  * = $HOME-git-managed;         ^ = symlink-mirrored, not suited for git;
          + = individually git-managed;  ! = lose-able;
          & = used by system


## FAQs

**Q: Which OSs can I use with Code4Real?**

A: Most Linux distro families are supported/tested: Arch, Debian (and Ubuntu,
etc), Red Hat (centos, fedora). FreeBSD and derivatives (PC-BSD) also works.

You can even use a Mac, though I encourage you to try out another more open
system. There are several easy and free ways (VirtualBox or USB-stick image)
to try out Linux or BSD.

**Q: Which OS do you recommend?**

A: Prefer an OS that is as "open" as possible.

We presently use *Arch Linux* more than the others. It's very convenient to
have a rolling release, and the *yaourt* package manager makes for a very
strong means to share projects. Linux runs just about everywhere, so it's a
great choice if you're worried about hardware support.

*PC-BSD* is a really friendly OS to install, and pkgng makes installing packages
really easy. It's also an extension to the very robust FreeBSD, which is a
high performing server supporting ZFS and sophisticated system debugging via
DTrace.

**Q: What about MS Windows support?**

A: We went quite a ways down the path of trying to make it work, but in the end
there was too much heartache around getting NodeJS to run well, and Cygwin is
different enough and hard enough for students to install, that it proved to be
unsupportable.

**Q: I prefer the ABC tool over the XYZ tool you've selected.**

A: This setup can be customized to your liking. Feel free to use Emacs instead
of Vim, for example. But many of the tutorials that are part of Code4Real will
be featuring the supported tools that are included.

**Q: Why use symlinks instead of the real files in $HOME?**

A: Maintaining your important files as symbolic links makes them easier to
manage and separate from all the other config files that are dumped there by
the dozens of other tools you use. This is life until everyone adopts the [XDG
standards](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html),
which may never happen. Manually creating symlinks to the files you actually
want to track is a useful explicit step to document such intention.

**Q: Why vim instead of gvim?**

A: You'll have many occasions to be running your editor remotely. Graphical
tools are less useful for such situations. Vim/URxvt/tmux is usually a better
combination of fonts and windows for remote work, and arguably for local.


## Alternative environments

There are other pre-packaged setup environments. This Code4Real stack is
minimalistic and prescriptive but tries to take care of all the essential
tools needed for highly productive programming (and learning). If you'd like
to experiment with other more specific stacks, give the following a look.
Whichever combination you end up with, get to know it intimately and customize
it to your tastes.

* [GRML](https://grml.org/zsh/) -- a Zsh "distribution" used on Debian and
  elsewhere

* [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh) -- a
  community-driven framework for managing your zsh configuration

* [SPF13](http://vim.spf13.com/) -- a distribution of vim plugins and
  resources for Vim, GVim and MacVim

* [Janus](https://github.com/carlhuda/janus) -- a distribution of plug-ins and
  mappings for Vim, Gvim and MacVim

* [Emacs](https://www.gnu.org/software/emacs/) -- the only other text editor
  comparable in features and power to Vim. Lacks Vim's light-weightedness and
  mnemonic command mode, but features a Lisp-oriented extension system (a good
  thing) and largely renders a separate terminal/shell as unnecessary.
