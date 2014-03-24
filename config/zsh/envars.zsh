######################################################################
# Envars
#
# Things that are only used by Zsh should not be exported.
######################################################################

# ???: Maybe didn't want anything to look like DOS.
unset USERNAME

HISTIGNORE='k:ls:lm:bg:fg:jobs:pwd:kill:declare:history:cd:cd :&: *:'
HISTSIZE=20000
HISTFILESIZE=$HISTSIZE
#export HISTFILE=~/.history/bh-$$

# Mail agents need to see these
export EDITOR=vim
export XEDITOR=$EDITOR
export VISUAL=$EDITOR
#export VIMTAGS
export TMPDIR=~/tmp
export BROWSER=firefox-aurora  # previously: chromium, google-chrome
export CHROME_BIN=/usr/bin/chromium
export DE=i3 # must be Desktop Environment (was xfce in archbang's .xinitrc)
export MAILCHECK=60

export IMGEDITOR=gimp
export IMGVIEWER=feh
export VPLAYER=smplayer
export APLAYER=mplayer

# Pager stuff
#export PAGER=most
#export PAGER=vimpager
export PAGER=less
# Enable ipython to display color sequences in PAGER (http://zi.ma/9e4f04)
export LESS='-F -R -S -X'
# Make less more friendly for non-text input files, see lesspipe(1)
# Set LESSOPEN/LESSCLOSE.
[[ -x /usr/bin/lesspipe ]] && eval "$(lesspipe)"
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\e[01;31m'       # ??
export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # headings
export LESS_TERMCAP_me=$'\e[0m'           # end
export LESS_TERMCAP_us=$'\e[04;38;5;82m' # emphasis
export LESS_TERMCAP_ue=$'\e[0m'           # end
export LESS_TERMCAP_so=$'\e[1;38;5;226;48;5;236m'    # footer, search, etc
export LESS_TERMCAP_se=$'\e[0m'           # end

export READNULLCMD=less

export EMAIL=$my_email
export REPLYTO=$EMAIL
export HGUSER="$my_fullname ($(hostname -s)) <$my_email>"
export HGMERGE=vimdiff
export HGEDITOR=hgeditor
export INPUTRC=~/.inputrc

# Python
# My personal python modules.
export VIRTUAL_ENV_DISABLE_PROMPT=1
export VIRTUALENV_USE_DISTRIBUTE=1
export WORKON_HOME=$HOME/.virtualenvs
export DJANGO_SETTINGS_MODULE=settings

export RLWRAP_EDITOR="$EDITOR -c ':set filetype=clojure'"
export RLWRAP_OPTIONS='--multi-line -pyellow --remember --complete-filenames --histsize 10000'

# TERM should be set in ~/.Xdefaults, if at all.
#export TERM=linux
#test "$OSTYPE" = "cygwin" &&
#    export TERM=dumb ||
#    export TERM=xterm
#export TERM=xterm
#export TERM=xterm-256color
export XTERM=urxvtcd
export TERMINAL=$XTERM

# Home path areas
# NOTE: ~/local is early since it should only be used to replace sys utils
export PATH=$HOME/bin:$HOME/local/bin:$HOME/contrib/bin:$PATH
# System path areas
# NOTE: stuff like /usr/local/bin should be added by any system, so
# don't want to duplicate them here.

# chruby, completion, autoswitching (installed via yaourt)
print "ENABLE: install rubies with ruby-installer"
print "https://github.com/postmodern/ruby-install\n"
print "ENABLE: chruby for loading multiple rubies"
print "https://github.com/postmodern/chruby\n"
##source /usr/share/chruby/chruby.sh
##source /usr/share/chruby/auto.sh
# https://github.com/postmodern/chruby/issues/27#issuecomment-16911865
##compctl -g '~/.rubies/*(:t)' chruby

# nvm: See ni/jsi funcs. Just a little too slow for every shell.

# Node http://tnovelli.net/blog/blog.2011-08-27.node-npm-user-install.html
export PATH=$HOME/.local/bin:$PATH

export DEBUG='brunch:*'

# R
##export PATH=$PATH:/usr/lib/R/bin
##export PERL5LIB=$PERL5LIB:/usr/share/R/share/perl

# Haskell cabal stuff.
#export PATH=$HOME/.cabal/bin:$PATH

# Android SDK
##export PATH=$PATH:/opt/android-sdk/platform-tools
##export PATH=$PATH:/opt/android-sdk/tools

# Recent Groovy
##export PATH=$HOME/opt/groovy-1.8.1/bin:$PATH

# Clojure
##export PATH=$HOME/.lein/bin:$PATH

# Gitcontainer binstubs
##export PATH=$PATH:$HOME/gitcontainer/bin

# Local dir stuff.
export PATH=$PATH:./bin

## COLORS ############################################################
# Make dircolors work on non-RH systems.
[[ -e "$HOME/.dir_colors" ]] && export DIR_COLORS="$HOME/.dir_colors"
[[ -e "$DIR_COLORS" ]] || DIR_COLORS=""
# Must here trick dircolors into not seeing "256color".
# Results in “export LS_COLORS=…”
eval "$(TERM=xterm dircolors -b $DIR_COLORS)"

# Handy custom envars.
dn=/dev/null

# Archlinux dictionary
dict=/usr/share/dict/american-english

lh='localhost:3000'

#-- Bottom Matter ----------------------------------------------------

# I think this will uniqify PATH in case this file is re-sourced.
# Appears to need to be down here at bottom.
# http://www.zsh.org/mla/users/1998/msg00490.html
typeset -U path

# Trying this too since saw it growing
typeset -U fpath
