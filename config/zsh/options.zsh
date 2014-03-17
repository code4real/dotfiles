# Zsh-specific options and params setup.
# See zshoptions for setopt stuff.
# See zshparam for envars that affect environment.
# Note that vars like CDPATH/cdpath, PATH/pathstay in sync when you edit
# just one. Lower-cased is the convenient array form.


######################################################################
### Params (need to come before autoload stuff)

# Search path for function defs; add mine here.
# System completions live in:
#   /usr/share/zsh/functions/Completion/Unix/
# so have a local personal dir similar.
#fpath=( $fpath ~/config/zfunc )
# My funcs.
fpath=( ~/config/zsh/functions $fpath )
# My prompts.
fpath=( ~/config/zsh/prompts $fpath )
# Contrib funcs.
fpath=( ~/contrib/zsh/functions $fpath )

# Zsh book pg 334
fpath=( ~/config/zsh/zfunc $fpath )
autoload -- ~/config/zsh/zfunc/[^_]*(:t)

# This is awesome! Tab-completion works to expand these!
# Needs to only include dirs that don’t have lots of subdirs.
# Test the reach of this with ‘mkdir foo; cd foo; cd <tab>; rmdir foo’
cdpath=( ~/proj ~/gitcontainer/gists ~/config ~/clients )
# cd-able locations. Also awesome. Going with convention of 'd' prefix
# to later enable some completion of "cd d«tab»" to expand only cdables,
# since presently there's no reasonable way for zsh to know which of so
# many envars to expand.
dsrc=~/archive/src

######################################################################
### Funky stuff — not exactly options/params

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit; compinit

print "ENABLE: install fonts (maybe orp) in set in ~/.Xdefaults"
print "https://github.com/MicahElliott/Orp-Font\n"

## Help system
# According to:
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#SEC267
# you need to set HELPDIR to make mini-help with run-help work.
print "ENABLE: zsh built-in run-help, if not on system (ex: /usr/share/zsh/5.0.5/help/)"
print "  by downloading/extracting zsh sources.\n"
#unalias run-help
#autoload run-help
# Manual steps:
#   cd ~/tmp"
#   wget 'http://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.bz2'"
#   tar xjvf 'http://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.bz2'"
#   perl zsh-5.0.5/Util/helpfiles zshbuiltins ~/local/doc/zsh/help"
#HELPDIR=~/local/doc/zsh/help
HELPDIR=/usr/share/zsh/5.0.5/help
bindkey "^[h" run-help
bindkey "^[H" run-help

# Arch zsh packages.
# https://github.com/zsh-users/zsh-syntax-highlighting/tree/master/highlighters
# Options:
print "ENABLE: zsh syntax highlighting"
print "https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/highlighters/main/main-highlighter.zsh\n"
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets pattern )
# Hmm, just basic colors? rgybmc
#ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=cyan
#ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=cyan,bold
#ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=fg=white,standout
#ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
#ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=magenta
#ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
#ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
#ZSH_HIGHLIGHT_STYLES[assign]=fg=blue

# Doesn't seem to work.
#source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# SLOW!!
#source /usr/share/zsh/scripts/antigen/antigen.zsh

# Prompt.
setopt promptsubst
autoload -Uz promptinit; promptinit
autoload -Uz vcs_info; vcs_info
autoload -Uz colors; colors
# Set prompt to random color.
#prompt balance $(( $RANDOM % 9 ))
#prompt balance black
prompt code4real
#prompt wunjo
#prompt off

autoload zmv

# My funcs.
autoload v foofunc

# Mime types; enable massive set of "alias -s" (MAYBE SLOW)
#autoload -U zsh-mime-setup; zsh-mime-setup

# Multibyte/unicode character input based on mnemonics, a la vim's Ctrl-K
# http://zsh.sourceforge.net/FAQ/zshfaq05.html
autoload -Uz insert-composed-char
zle -N insert-composed-char
# Map it to <F5>
#bindkey '\e[15~' insert-composed-char  # F5
bindkey '^K' insert-composed-char  # same as vim

### Custom inserts
# CTRLs available: ^r ^t ^y ^o ^p ^a ^f ^b ^n
# ALT/ESC example: bindkey '^[f' foo
# Ideas:
# https://github.com/tomsquest/dotfiles/blob/master/zsh/bindkey.zsh
# http://michael-prokop.at/computer/config/.zsh/zsh_keybindings
# Insert an mc3 query.
#insert_query () { zle beginning-of-line; zle -U "mc3q '{}' _id" }
#insert-mc3q() { LBUFFER="opts=--csv mc3q '{"; RBUFFER=":\"\"}' _id |csv2tsv.rb S" }
insert-mc3q() { LBUFFER="opts=--csv mc3q '{\""; RBUFFER="\"://i, abandon:{\$ne:true}}' _id TSV" }
zle -N insert-mc3q
bindkey '^f' insert-mc3q
insert-mc3s() { LBUFFER="mc3s "; RBUFFER=" J" }
zle -N insert-mc3s
bindkey '^[f' insert-mc3s
# Calculator
insert-calc() { LBUFFER='p $(('; RBUFFER='))' }
zle -N insert-calc
#bindkey '^f' insert-mc3q
bindkey '^[c' insert-calc
# Sed
insert-sed() { LBUFFER+="s 's/" RBUFFER="//'" }
zle -N insert-sed
bindkey '^[s' insert-sed

# Set vi mode.
#bindkey -e
bindkey -v
# Not necesssary and not recommended (according to zshoptions);
# might also be getting settings from inputrc.
#setopt vi
# Workaround for funny Ubuntu setting.
bindkey '\e/' vi-history-search-backward

# zsh-specific command finder
# Two bugs!
# https://bugs.launchpad.net/ubuntu/+source/command-not-found/+bug/624565
#. /etc/zsh_command_not_found

# Do menu-driven completion.
zstyle ':completion:*' menu select

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# http://www.masterzen.fr/category/system-administration/zsh-system-administration/
#zstyle ':completion:*' group-name ''
# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# Completers for my own scripts
zstyle ':completion:*:*:sstrans*:*' file-patterns '*.(lst|clst)'
zstyle ':completion:*:*:ssnorm*:*' file-patterns '*.tsv'


######################################################################
### Options

setopt interactivecomments
# Don't exit on ^D
setopt ignoreeof

# Changing dirs.
setopt cdablevars pushdignoredups pushdsilent chaselinks

# Enable ~ ^ # in glob patterns.
setopt extendedglob

# Too many scripts use globals or forget to make local.
#setopt warncreateglobal

# Report on bg jobs immediately when they finish.
setopt notify

# History
setopt appendhistory banghist histignorealldups histfindnodups
setopt histignorespace histnostore histreduceblanks histsavenodups
setopt incappendhistory extendedhistory

setopt nocaseglob
setopt correct

# Kinda cool, but eventually annoying to have all shells share hist in
# real-time. Better to just use "fc -RI" to Read Incrementallly the
# missing shared entries.
#setopt sharehistory

# Nice safety, Was just too annoying to have to hit <enter> after !$
#setopt histverify

# Neat! Can say "subdir/myutil" to invoke myutil.
setopt pathdirs

# Enable char ranges in brace expansions: for c in {a-z}; do ...
setopt braceccl

# Don’t overwrite existing files.
setopt noclobber

# Fancy regexes in =~
setopt rematchpcre

setopt shortloops

setopt brace_ccl  # Support chars in range: {a-z}
                  # Note difference from:   {0..9}

# Trying out 0-based arrays! Matches bash and ls
setopt kshzerosubscript

setopt numericglobsort

# Enable some nice things to go into post-prompt commands.
typeset -ga preexec_functions
typeset -ga precmd_functions

# Bail out of scripts as soon as the first error hits.
#setopt errexit

# Zsh-specific envar overrides for history control. Behave more like
# options than envars.
# http://zsh.sourceforge.net/FAQ/zshfaq03.html#l38
SAVEHIST=10000
HISTFILE=$HOME/.zhistory
HISTSIZE=10000

# Stop Esc-* from acting like Alt-*, and save time!
# http://www.johnhawthorn.com/2012/09/vi-escape-delays/
KEYTIMEOUT=1

# Consider MIME filetype enabling. SLOW!
# http://www.bash2zsh.com/essays/essay1_file_manager.html
#autoload -U zsh-mime-setup; zsh-mime-setup

umask 002

# Modal cursor color for vi's insert/normal modes.
# https://bbs.archlinux.org/viewtopic.php?id=95078
zle-keymap-select () {
  if [ $KEYMAP = vicmd ]; then
    #echo -ne "\033]12;Red\007"
    echo -ne "\033]12;Green\007"
  else
    echo -ne "\033]12;Grey\007"
  fi
}
zle -N zle-keymap-select
zle-line-init () {
  zle -K viins
  echo -ne "\033]12;Grey\007"
}
zle -N zle-line-init

# Set tabs to non-standard (non-8) width.
# See: `man 1p tabs` for some interesting options!
tabs -16

# Disable C-s as XOFF
# https://coderwall.com/p/ltiqsq
stty stop ''
stty start ''
stty -ixon
stty -ixoff

# Misc completions (should I have a zstyle.zsh file?)
# FIXME: Not completing dirs
zstyle ':completion:*:*:mp4crush*:*' file-patterns '*.mp4'
zstyle ':completion:*:*:bkgd:*' file-patterns '*.jpg'
zstyle ':completion:*:*:feh:*' file-patterns '*.(jpg|png)'
zstyle ':completion:*:*:mb-purge-non-deliverables*:*' file-patterns '*.txt'
zstyle ':completion:*:*:(v|vim):*' ignored-patterns '*.(o|so|mp3|jpg|png|pdf|xcf)'
